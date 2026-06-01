---
Title: "{{title | replace('"', '\\"')}}"
Authors: {{ authors }}
First_author: "{%- set fa = creators | selectattr('creatorType', 'equalto', 'author') | first -%}{{fa.lastName + ', ' + fa.firstName if fa else ''}}"
Year: {{date|format("YYYY")}}
Publisher: {{publicationTitle}}
Keywords: [{{allTags}}]
Citekey: {{citekey}}
Tags:
Status: reading

---

```meta-bind-button
label: "📖 Reading"
style: default
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: reading
```

```meta-bind-button
label: "⚛️ Make Atomic"
style: default
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: make-atomic
```

```meta-bind-button
label: "✅ Done"
style: default
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: done
```

---

# Self Notes

{% persist "notes" %}

## Why I'm reading this

-

## Summary / Thoughts

-

{% endpersist %}

---

# Keys

{%-
    set zoteroColors = {
        "#2ea8e5": "blue",
        "#5fb236": "green",
        "#a28ae5": "purple",
        "#ff6666": "red",
        "#ffd400": "yellow",
        "#f19837": "orange",
        "#aaaaaa": "grey",
        "#e56eee": "magenta"
    }
%}

## Foundational Landscapes

- **GREY**: Textbook definitions, universal biophysical principles, cable theory, and known background anatomy. The "who gets credit" test = a textbook student already knows this.
  - Given academic reading is a lot of context and setup, might be good to have tags e.g.
  - **G** is for geography (lay of the land inforamtion); "Okay, that's what that part is called,"
  - **M** is for the mechanics; "Oh, that's an interesting rule for how things work,"

## Structure & Core Logic

- **GREEN**: The exact problem the authors are trying to solve, or the gap in current literature.
- **PURPLE**: The ultimate punchlines of the paper. Only highlight the actual breakthrough or final takeaway here.

## Evidence & Context

- **YELLOW**: What THEY looked at + How THEY looked at it + What THEY physically saw. (Strictly for the work done in this specific paper).
- **BLUE**: Specific data points, statistics, or visual chart references within that narrative.

## Personal Processing

- **ORANGE**: Author biases, small sample sizes, limitations, or things that contradict your own data. Your active critical thinking color.
- **RED**: Things you MUST do next. "Look up this code repository," "Replicate this math," or "Check if this applies to my current project."
- **MAGENTA**: Used for breaking sections of the text, so  that we have more context when revisiting the notes

{%-
    set colorHeading = {
        "grey": "📅 Foundational Landscape (Definitions & Mechanics)",
        "green": "❓ The Pivot (Problem, Question, Gap)",
        "purple": "📊 Ultimate Claims & Final Takeaways",
        "yellow": "🔬 Core Narrative (What They Did & Saw)",
        "blue": "📈 Data Points & Figures",
        "orange": "⚠️ Critical Friction (Disagreements & Limitations)",
        "red": "‼️ Follow-ups & Immediate Action",
        "magenta": "Context Sections"
    }
%}

# 📜 Notes in Sequential Order

{%- macro resolveColor(annot) -%}
{%- if zoteroColors[annot.color] -%}
{{- zoteroColors[annot.color] -}}
{%- elif annot.colorCategory|lower in colorHeading -%}
{{- annot.colorCategory|lower -}}
{%- else -%}
other
{%- endif -%}
{%- endmacro -%}

{%- set allAnnotations = [] -%}
{%- set pageNumbers = [] -%}
{%- for annot in annotations -%}
{%- set customColor = resolveColor(annot) -%}
{%- set allAnnotations = (allAnnotations.push({"annotation": annot, "customColor": customColor}), allAnnotations) -%}
{%- set p = annot.pageLabel | int -%}
{%- if p not in pageNumbers -%}
{%- set pageNumbers = (pageNumbers.push(p), pageNumbers) -%}
{%- endif -%}
{%- endfor -%}
{%- set pageNumbers = pageNumbers | sort -%}

{%- for page in pageNumbers %}
{%- set pageAnnotations = [] -%}
{%- for entry in allAnnotations -%}
{%- if entry.annotation.pageLabel | int == page -%}
{%- set pageAnnotations = (pageAnnotations.push(entry), pageAnnotations) -%}
{%- endif -%}
{%- endfor -%}
{%- for entry in pageAnnotations %}

> [!quote|{{entry.customColor}}]+ {{entry.annotation.type | capitalize}} · {{colorHeading[entry.customColor]}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
> {%- if entry.annotation.annotatedText %}
> {{entry.annotation.annotatedText|replace("\n", " ")}}{% if entry.annotation.hashTags %} {{entry.annotation.hashTags}}{% endif %}
> {%- endif %}
> {%- if entry.annotation.imageRelativePath %}
> ![[{{entry.annotation.imageRelativePath}}]]
> {%- endif %}
> {%- if entry.annotation.ocrText %}
> {{entry.annotation.ocrText}}
> {%- endif %}
> {%- if entry.annotation.comment %}
>
> - {{entry.annotation.comment|replace("\n", " ")}}
>   {%- endif %}

{%- endfor %}
{%- endfor %}

---

Gratitude: Adapted from [muhammadammarzahid/zotero_obsidian](https://raw.githubusercontent.com/muhammadammarzahid/zotero_obsidian/refs/heads/main/zotero_integration.md)
