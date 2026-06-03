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
`BUTTON[status-reading, status-atomic, status-done]`
```meta-bind-button
label: "📖 Reading"
style: default
id: status-reading
hidden: true
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: reading
```
```meta-bind-button
label: "⚛️ Make Atomic"
style: default
id: status-atomic
hidden: true
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: make-atomic
```
```meta-bind-button
label: "✅ Done"
style: default
id: status-done
hidden: true
action:
  type: updateMetadata
  bindTarget: Status
  evaluate: false
  value: done
```
---

# Self Notes

## Why I'm reading this
{% persist "why_reading" %}

-
{% endpersist %}

## Summary / Thoughts
{% persist "summary_thoughts" %}

-
{% endpersist %}

---

# ToC

- [[#📜 Notes in Sequential Order]]

- [[#🗂️ Notes by Color]] 
	- [[#📅 Foundational Landscape (Definitions & Mechanics)]]
	- [[#❓ The Pivot (Problem, Question, Gap)]]
	- [[#📊 Ultimate Claims & Final Takeaways]]
	- [[#🔬 Core Narrative (What They Did & Saw)]]
	- [[#📈 Data Points & Figures]]
	- [[#⚠️ Critical Friction (Disagreements & Limitations)]]
	- [[#‼️ Follow-ups & Immediate Action]]

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
  - **G** is for geography (lay of the land information); "Okay, that's what that part is called,"
  - **M** is for the mechanics; "Oh, that's an interesting rule for how things work,"
  - **Defn** is for definitions; term + description, ripe for atomic notes.

## Structure & Core Logic

- **GREEN**: The exact problem the authors are trying to solve, or the gap in current literature.
- **PURPLE**: The ultimate punchlines of the paper. Only highlight the actual breakthrough or final takeaway here.

## Evidence & Context

- **YELLOW**: What THEY looked at + How THEY looked at it + What THEY physically saw. (Strictly for the work done in this specific paper).
- **BLUE**: Specific data points, statistics, or visual chart references within that narrative.

## Personal Processing

- **ORANGE**: Author biases, small sample sizes, limitations, or things that contradict your own data. Your active critical thinking color.
- **RED**: Things you MUST do next. "Look up this code repository," "Replicate this math," or "Check if this applies to my current project."
- **MAGENTA**: Used for breaking sections of the text, so that we have more context when revisiting the notes.

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

{%- macro resolveColor(annot) -%}
{%- if zoteroColors[annot.color] -%}
{{- zoteroColors[annot.color] -}}
{%- elif annot.colorCategory|lower in colorHeading -%}
{{- annot.colorCategory|lower -}}
{%- else -%}
other
{%- endif -%}
{%- endmacro -%}

{%- macro greyPrefix(comment) -%}
{%- set ct = comment | trim | lower if comment else "" -%}
{%- if ct.startsWith("m:") -%}Mechanism
{%- elif ct.startsWith("g:") -%}Geography
{%- elif ct.startsWith("defn:") -%}Definition
{%- else -%}Note
{%- endif -%}
{%- endmacro -%}

{%- macro stripPrefix(comment) -%}
{%- set ct = comment | trim | lower if comment else "" -%}
{%- if ct.startsWith("m:") -%}
{{- comment | replace("M:", "") | replace("m:", "") | trim -}}
{%- elif ct.startsWith("g:") -%}
{{- comment | replace("G:", "") | replace("g:", "") | trim -}}
{%- elif ct.startsWith("defn:") -%}
{{- comment | replace("Defn:", "") | replace("defn:", "") | trim -}}
{%- else -%}
{{- comment | trim -}}
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

---

# 📜 Notes in Sequential Order

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
> {%- if entry.customColor == "grey" %}
> - **{{greyPrefix(entry.annotation.comment)}}:** {{stripPrefix(entry.annotation.comment)|replace("\n", " ")}}
> {%- else %}
> - {{entry.annotation.comment|replace("\n", " ")}}
> {%- endif %}
> {%- endif %}

{%- endfor %}
{%- endfor %}

---

# 🗂️ Notes by Color %% fold %%

{# --- NON-GREY COLORS IN ORDER --- #}
{%- for color, heading in colorHeading -%}
{%- if color != "grey" -%}
{%- set colorEntries = allAnnotations | filterby("customColor", "startswith", color) -%}
{%- if colorEntries.length > 0 %}

## {{heading}}

{%- for entry in colorEntries %}

> [!quote|{{entry.customColor}}]+ {{entry.annotation.type | capitalize}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
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
> {%- endif %}

{%- endfor %}
{%- endif %}
{%- endif %}
{%- endfor %}

{# --- GREY SPLIT INTO G / M / DEFN / OTHER --- #}
{%- set greyEntries = allAnnotations | filterby("customColor", "startswith", "grey") -%}
{%- if greyEntries.length > 0 %}

## 📅 Foundational Landscape (Definitions & Mechanics)

{%- set mechEntries = [] -%}
{%- set geoEntries = [] -%}
{%- set defnEntries = [] -%}
{%- set otherGreyEntries = [] -%}
{%- for entry in greyEntries -%}
  {%- set ct = entry.annotation.comment | trim | lower if entry.annotation.comment else "" -%}
  {%- if ct.startsWith("m:") -%}
    {%- set mechEntries = (mechEntries.push(entry), mechEntries) -%}
  {%- elif ct.startsWith("g:") -%}
    {%- set geoEntries = (geoEntries.push(entry), geoEntries) -%}
  {%- elif ct.startsWith("defn:") -%}
    {%- set defnEntries = (defnEntries.push(entry), defnEntries) -%}
  {%- else -%}
    {%- set otherGreyEntries = (otherGreyEntries.push(entry), otherGreyEntries) -%}
  {%- endif -%}
{%- endfor -%}

{%- if defnEntries.length > 0 %}

### 📖 Definitions

{%- for entry in defnEntries %}

> [!quote|grey]+ {{entry.annotation.type | capitalize}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
> {{entry.annotation.annotatedText|replace("\n", " ")}}{% if entry.annotation.hashTags %} {{entry.annotation.hashTags}}{% endif %}
>
> - **Definition:** {{stripPrefix(entry.annotation.comment)|replace("\n", " ")}}

{%- endfor %}
{%- endif %}

{%- if geoEntries.length > 0 %}

### 🗺️ Geography

{%- for entry in geoEntries %}

> [!quote|grey]+ {{entry.annotation.type | capitalize}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
> {{entry.annotation.annotatedText|replace("\n", " ")}}{% if entry.annotation.hashTags %} {{entry.annotation.hashTags}}{% endif %}
>
> - **Geography:** {{stripPrefix(entry.annotation.comment)|replace("\n", " ")}}

{%- endfor %}
{%- endif %}

{%- if mechEntries.length > 0 %}

### 🧠 Mechanisms

{%- for entry in mechEntries %}

> [!quote|grey]+ {{entry.annotation.type | capitalize}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
> {{entry.annotation.annotatedText|replace("\n", " ")}}{% if entry.annotation.hashTags %} {{entry.annotation.hashTags}}{% endif %}
>
> - **Mechanism:** {{stripPrefix(entry.annotation.comment)|replace("\n", " ")}}

{%- endfor %}
{%- endif %}

{%- if otherGreyEntries.length > 0 %}

### 📝 General Context

{%- for entry in otherGreyEntries %}

> [!quote|grey]+ {{entry.annotation.type | capitalize}} ([page. {{entry.annotation.pageLabel}}](zotero://open-pdf/library/items/{{entry.annotation.attachment.itemKey}}?page={{entry.annotation.pageLabel}}&annotation={{entry.annotation.id}}))
> {{entry.annotation.annotatedText|replace("\n", " ")}}{% if entry.annotation.hashTags %} {{entry.annotation.hashTags}}{% endif %}
> {%- if entry.annotation.comment %}
>
> - {{entry.annotation.comment|replace("\n", " ")}}
> {%- endif %}

{%- endfor %}
{%- endif %}

{%- endif %}

---

Gratitude: Adapted from [muhammadammarzahid/zotero_obsidian](https://raw.githubusercontent.com/muhammadammarzahid/zotero_obsidian/refs/heads/main/zotero_integration.md)