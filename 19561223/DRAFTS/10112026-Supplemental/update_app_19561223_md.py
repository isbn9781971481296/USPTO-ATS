path = '/media/user/t1/ASSETS/USPTO/Dockets/ATS/app_19561223.md'
with open(path) as f:
    text = f.read()

target = """| Submission Date | Response Package Description | Docket Status | Submitted PDF Documents (1-to-Many) |
| :--- | :--- | :---: | :--- |
| `2026-10-10` | **Response to Notice to File Missing Parts & Suspension Request** | **Verified Filing (Official USPTO Receipt on File)** | - [19561223-EXTENSION-OF-TIME-10102026.pdf](19561223/DRAFTS/10102026/19561223-EXTENSION-OF-TIME-10102026.pdf) (90 KB)<br>- [19561223-REQUEST-FOR-SUSPENSION-1103A-10102026.pdf](19561223/DRAFTS/10102026/19561223-REQUEST-FOR-SUSPENSION-1103A-10102026.pdf) (75 KB)<br>- [19561223-RESPONSE-INCOMPLETE-REPLY-10102026.pdf](19561223/DRAFTS/10102026/19561223-RESPONSE-INCOMPLETE-REPLY-10102026.pdf) (99 KB) |"""

replacement = """| Submission Date | Response Package Description | Docket Status | Submitted PDF Documents (1-to-Many) |
| :--- | :--- | :---: | :--- |
| `2026-10-11` | **Supplemental Response to Notice of Incomplete Reply & Full Fee Remittance** | **Prepared Supplemental Filing (Full Cash Remittance)** | - [19561223-SUPPLEMENTAL-RESPONSE-10112026.pdf](19561223/DRAFTS/10102026-Supplemental/19561223-SUPPLEMENTAL-RESPONSE-10112026.pdf)<br>- [19561223-SUPPLEMENTAL-EXTENSION-OF-TIME-10112026.pdf](19561223/DRAFTS/10102026-Supplemental/19561223-SUPPLEMENTAL-EXTENSION-OF-TIME-10112026.pdf)<br>- [19561223-SUPPLEMENTAL-REQUEST-FOR-SUSPENSION-10112026.pdf](19561223/DRAFTS/10102026-Supplemental/19561223-SUPPLEMENTAL-REQUEST-FOR-SUSPENSION-10112026.pdf) |
| `2026-10-10` | **Response to Notice to File Missing Parts & Suspension Request** | **Verified Filing (Official USPTO Receipt on File)** | - [19561223-EXTENSION-OF-TIME-10102026.pdf](19561223/DRAFTS/10102026/19561223-EXTENSION-OF-TIME-10102026.pdf) (90 KB)<br>- [19561223-REQUEST-FOR-SUSPENSION-1103A-10102026.pdf](19561223/DRAFTS/10102026/19561223-REQUEST-FOR-SUSPENSION-1103A-10102026.pdf) (75 KB)<br>- [19561223-RESPONSE-INCOMPLETE-REPLY-10102026.pdf](19561223/DRAFTS/10102026/19561223-RESPONSE-INCOMPLETE-REPLY-10102026.pdf) (99 KB) |"""

if target in text:
    new_text = text.replace(target, replacement)
    with open(path, 'w') as f:
        f.write(new_text)
    print("app_19561223.md successfully updated!")
else:
    print("Target not found in app_19561223.md")
