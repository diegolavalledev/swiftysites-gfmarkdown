#include "include/cmark_gfm_markdown_to_html.h"

#include "cmark-gfm.h"
#include "cmark-gfm-core-extensions.h"

// This is a function that will make enabling extensions easier later on.
void addMarkdownExtension(cmark_parser *parser, char *extName) {
    cmark_syntax_extension *ext = cmark_find_syntax_extension(extName);
    if (ext) {
        cmark_parser_attach_syntax_extension(parser, ext);
    }
}

/// A function to convert HTML to Github Flavored Markdown (GFM)
char *cmark_gfm_markdown_to_html(const char *text, size_t len, int options, char** extensions, int extensionsCount) {
    cmark_gfm_core_extensions_ensure_registered();

    // Modified version of cmark_parse_document in blocks.c
    cmark_parser *parser = cmark_parser_new(options);

    // Add extensions here
    for (int i = 0; i < extensionsCount; i++) {
        addMarkdownExtension(parser, extensions[i]);
    }

    cmark_node *doc;
    cmark_parser_feed(parser, text, len);
    doc = cmark_parser_finish(parser);
    cmark_parser_free(parser);

    // Render
    char *html = cmark_render_html(doc, options, NULL);
    cmark_node_free(doc);

    return html;
}
