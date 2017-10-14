#!/bin/bash -e

markdown_source=$1
html_target=$2

highlight_style=zenburn
extensions=(
    fenced_code_attributes
    definition_lists
    escaped_line_breaks
    strikeout
    shortcut_reference_links
    footnotes
    abbreviations
)

template=style/template.html

echo "Compile ${html_target}"

mkdir -p `dirname ${html_target}`

format=markdown
for extension in ${extensions[@]};
do
  format="${format}+${extension}"
done

pandoc \
      -s \
      -f ${format} \
      --smart \
      --email-obfuscation=references \
      --highlight-style=${highlight_style} \
      -t html5 \
      --template ${template} \
      --metadata=from:${markdown_source} \
      --metadata=to:${html_target} \
      -o ${html_target} \
      ${markdown_source}
