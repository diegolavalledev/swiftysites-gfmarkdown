#ifndef cmark_gfm_markdown_to_html_h
#define cmark_gfm_markdown_to_html_h

#include <stdio.h>

char *cmark_gfm_markdown_to_html(const char *text, size_t len, int options, char** extensions, int extensionsCount);

#endif /* cmark_gfm_markdown_to_html_h */
