# Building and distributing

In order to build GFMarkdown from scratch we need to first compile the `cmark-gfm` library for macOS and Linux. We also need to target both supported architectures, namely `arm64` and `x86_64`. The binaries are then packaged as Xcode Frameworks and distributed via web links.

## Compiling cmark-gfm for macOS

On a Mac, download the source code for [cmark-gfm](https://github.com/github/cmark-gfm) and build using `CMake`.

```sh
git checkout https://github.com/github/cmark-gfm
cd cmark-gfm
mkdir build-macos build-macos-x86_64 build-macos-arm64
cd build-macos-x86_64

cmake --install-prefix "$PWD/sysroot" -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.10 -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..
make
make install
cp src/config.h sysroot/include/
make clean
cd ..
```

Now on to the ARM build.

```sh
cd build-macos-arm64
cmake --install-prefix "$PWD/sysroot" -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.10 -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..
make
make install
cp src/config.h sysroot/include/
make clean
cd ..
```

### Make a fat binary

We will use `lipo` to merge both architectures.

```sh
lipo -create build-macos-x86_64/sysroot/lib/libcmark-gfm.a build-macos-arm64/sysroot/lib/libcmark-gfm.a -output build-macos/libcmark-gfm.a
lipo -create build-macos-x86_64/sysroot/lib/libcmark-gfm-extensions.a build-macos-arm64/sysroot/lib/libcmark-gfm-extensions.a -output build-macos/libcmark-gfm-extensions.a
```

Before we can proceed to package the products in an Xcode Framework we need to build the Linux version of the library.

## Building cmark-gfm Linux

### Docker

To be able to generate the Linux binaries from a Mac, Docker can be uses.

#### Installation

If you need, install docker using Homebrew.

With an admin user.

```sh
brew install docker docker-machine
brew install --cask virtualbox
```

Fix permisions on _System Preferences > Security & Privacy_ and restart the computer.

With a regular user from the directory containing all repository checkouts.

```sh
docker-machine create --driver virtualbox default
eval $(docker-machine env default)
docker pull swiftlang/swift:nightly-5.5-focal
docker run -it -v "$PWD":"$PWD" --name linux swiftlang/swift:nightly-5.5-focal /bin/bash
exit
docker start linux
docker attach linux
```

In Docker, install CMake and the build essential packages to be able to build CMark-GFM. For Swift Packages with binary targets pointing to XCFramework zip archives, install the `unzip` tool.

```sh
apt update
apt install cmak build-essential unzip
cd cmark-gfm
mkdir build-linux
cd build-linux
cmake -DCMAKE_INSTALL_PREFIX="$PWD/sysroot" -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..
make
make install
cp src/config.h sysroot/include/
make clean
cd ..
exit
docker rm linux
```

Note that in Ubuntu the CMake flag `--install-prefix` appears to not have any effect so we use `-DCMAKE_INSTALL_PREFIX=` instead.

Also worth noting that in Ubuntu it is needed to swap the order in which the two libraries are build. This will prevent a linker error.

If pkgconfig is to be referenced from within `Package.swift` –not the preferred solution by this guide– then line 9 of `sysroot/lib/pkgconfig/libcmark-gfm.pc` should look somewhat like the following.

```sh
cat  sysroot/lib/pkgconfig/libcmark-gfm.pc
# …
# Libs: -L${libdir} -lcmark-gfm-extensions -lcmark-gfm
# …
```

## Create an Xcode Framework

We will need to do this individually for each of the libraries using a Mac.

### Main library

```sh
mkdir build
xcodebuild -create-xcframework -library build-macos/libcmark-gfm.a -headers build-macos-x86_64/sysroot/include -output build/cmark-gfm.xcframework
```

Xcode Frameworks do not officially support Linux as a platform but we can manually build it in.

```sh
cp -Rp build/cmark-gfm.xcframework/macos-arm64_x86_64 build/cmark-gfm.xcframework/linux-x86_64
rm build/cmark-gfm.xcframework/linux-x86_64/libcmark-gfm.a
cp build-linux/sysroot/lib/libcmark-gfm.a build/cmark-gfm.xcframework/linux-x86_64
```

Edit the property so that it contains the following snippet.

```sh
cat build/cmark-gfm.xcframework/Info.plist
# …
# <plist version="1.0">
# <dict>
# 	<key>AvailableLibraries</key>
# 	<array>
# 		<dict>…</dict>
# 		<dict>
# 			<key>HeadersPath</key>
# 			<string>Headers</string>
# 			<key>LibraryIdentifier</key>
# 			<string>linux-x86_64</string>
# 			<key>LibraryPath</key>
# 			<string>libcmark-gfm.a</string>
# 			<key>SupportedArchitectures</key>
# 			<array>
# 				<string>x86_64</string>
# 			</array>
# 			<key>SupportedPlatform</key>
# 			<string>linux</string>
# 		</dict>
# 	</array>
# 	…
# </dict>
# </plist>
```

Compress it with Zip.

```sh
cd build
zip -Xr cmark-gfm.xcframework.zip cmark-gfm.xcframework
cd ..
```

### Extensions library

We need to build a separate framework for the extensions part. The process is analogous to the that for main library.

```sh
xcodebuild -create-xcframework -library build-macos/libcmark-gfm-extensions.a -output build/cmark-gfm-extensions.xcframework
cp -Rp build/cmark-gfm-extensions.xcframework/macos-arm64_x86_64 build/cmark-gfm-extensions.xcframework/linux-x86_64
rm build/cmark-gfm-extensions.xcframework/linux-x86_64/libcmark-gfm-extensions.a
cp build-linux/sysroot/lib/libcmark-gfm-extensions.a build/cmark-gfm-extensions.xcframework/linux-x86_64

cat build/cmark-gfm-extensions.xcframework/Info.plist
# …
# <plist version="1.0">
# 		<dict>
# 			<key>LibraryIdentifier</key>
# 			<string>linux-x86_64</string>
# 			<key>LibraryPath</key>
# 			<string>libcmark-gfm-extensions.a</string>
# 			<key>SupportedArchitectures</key>
# 			<array>
# 				<string>x86_64</string>
# 			</array>
# 			<key>SupportedPlatform</key>
# 			<string>linux</string>
# 		</dict>
# 	</array>
# 	…
# </dict>
# </plist>

cd build
zip -Xr cmark-gfm-extensions.xcframework.zip cmark-gfm-extensions.xcframework
cd ..
```

### Distributing

The Zip files are suitable for uploading to the Web. On GitHub they can be attached to a release.

### Generate checksums

For users to be able to use these framework a checksum needs to be generated.

```sh
cd build
touch Package.swift
swift package compute-checksum cmark-gfm.xcframework.zip > cmark-gfm.checksum
swift package compute-checksum cmark-gfm-extensions.xcframework.zip > cmark-gfm-extensions.checksum
rm Package.swift
cd ..
```

## Consuming the Xcode Frameworks

The generated checksums can be used for using the XCFrameworks in binary target declarations.

```swift
let package = Package(
    name: "GFMarkdown",
    …
    targets: [
        .binaryTarget(name: "cmark-gfm",
            url: "https://github.com/swiftysites/gfmarkdown/releases/download/1.0.0/cmark-gfm.xcframework.zip", checksum: "f61664009f3fe1f3b88100a7a886682043ab7a234167bf579068472fe4472bec"
        ),
        .binaryTarget(name: "cmark-gfm-extensions",
            url: "https://github.com/swiftysites/gfmarkdown/releases/download/1.0.0/cmark-gfm-extensions.xcframework.zip", checksum: "97f674f4622bae79498ba835295d7dfa33b1de2989f29db0d0c17ec339ac0149"
        ),
        .target(
            name: "CMarkGFMPlus",
            dependencies: ["cmark-gfm", "cmark-gfm-extensions"],
            …
        ),
        …
    ]
    …
)
```

Alternativelly local paths to the un-archived frameworks can be used for development purposes.

```swift
let package = Package(
    …
    targets: [
        .binaryTarget(name: "cmark-gfm",
            path: "cmark-gfm/build/cmark-gfm.xcframework"
        ),
        .binaryTarget(name: "cmark-gfm-extensions",
            path: "cmark-gfm/build/cmark-gfm-extensions.xcframework"
        ),
        …
    ]
    …
)
```

### Linux

In order to use the Xcode Frameworks from Linux we need to add a few conditional settings as well as some unsafe flags to our package declaration.

```swift
let ARTIFACT_FRAGMENT = ".build/artifacts/GFMarkdown"
let ARTIFACT_FRAGMENT_LOWERCASE = ".build/artifacts/gfmarkdown"

let package = Package(
    name: "GFMarkdown",
    targets: [
        …
        .target(
            name: "CMarkGFMPlus",
            dependencies: ["cmark-gfm", "cmark-gfm-extensions"],
            cSettings: [
                .unsafeFlags([
                    "-I\(ARTIFACT_FRAGMENT)/cmark-gfm.xcframework/linux-x86_64/Headers",
                    "-I\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm.xcframework/linux-x86_64/Headers",
                ], .when(platforms: [.linux]))
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-L ../../\(ARTIFACT_FRAGMENT)/cmark-gfm.xcframework/linux-x86_64",
                    "-L ../../\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm.xcframework/linux-x86_64"
                    ], .when(platforms: [.linux])),
                .unsafeFlags([
                    "-L ../../\(ARTIFACT_FRAGMENT)/cmark-gfm-extensions.xcframework/linux-x86_64",
                    "-L ../../\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm-extensions.xcframework/linux-x86_64",
                    ], .when(platforms: [.linux])),
                .linkedLibrary(
                    "cmark-gfm-extensions", .when(platforms: [.linux])
                ),
                .linkedLibrary("cmark-gfm", .when(platforms: [.linux]))
            ]
        ),
        …
    ]
    …
)
```

It is important for the extensions library `cmark-gfm-extensions` to be declared _before_ the main `cmark-gfm` library.

#### Unsafe flags

Note that the use of unsafe flags will restrict the usage of the entire product in a way that it can only be added to an external Swift Package declaration with a specific revision tag.

```swift
let package = Package(
    name: "SwiftySites",
    …
    dependencies: [
        .package(url: "https://github.com/swiftysites/gfmarkdown", .revision("1.0.1")),
        …
    ],
    …
)
```

#### Testing in Linux

The use of `ARTIFACT_FRAGMENT_LOWERCASE` in the package definition is related to the fact that the artifact takes the name of the local folder when running tests.

```sh
cd gfmarkdown
swift test

# Will only work if ARTIFACT_FRAGMENT_LOWERCASE == ".build/artifacts/gfmarkdown" inside Package.swift.

```

## Clean up

```sh
rm -rf build build-macos build-linux build-macos-x86_64 build-macos-arm64 cmark-gfm-extensions.xcframework cmark-gfm-extensions.xcframework.zip cmark-gfm.xcframework cmark-gfm.xcframework.zip
```

## Building the Swift project

Once the dependencies are built and their corresponding binaries deployed, build the Swift project the usual way. Xcode can be used or the command line on both Mac or Linux.

```sh
swift build
```
