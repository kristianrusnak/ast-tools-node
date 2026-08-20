
# 00-architecture-documentation


Preface
TBD:

Document Purpose and Scope
Document describes our approach for documenting Technology Architecture (architecture description document). Technology Architecture shall be described using standardized form and blueprint with guidance shall be provided. 
This document is blueprint for describing documenting architecture for medium and large scale projects.
This document does not cover complete methodology for creating such documentation, not covers other areas outside Technology Architecture.
In short, it is explanation and guideline for “How to fill in Technology Architecture Documentation.template.docx on your project”.

Audience
Creators and readers of Technology Architecture Documentation.
Document Structure
Text in the individual chapters describes content that is expected to be covered by instances of Technical Architecture Documentation on individual projects. 
How to Use This Document
This document is designed to be read from beginning to end. Readers that are already familiar with concepts can reference individual View chapter as reference and content checklist for their architectural description documents. 
Each chapter (1-17) contains guidelines for what shall be covered in that particular chapter in Technical Architecture Documentation on actual project.

For simple systems, whole architecture can be described using single document. For complex systems, overview document shall exist and then each subsystem, layer, tier (or other categorization used) shall be described using this blueprint again. In that case the word “system” used in views descriptions (see individual chapters) can be substituted with “layer”, “component” or “class” according to level of detail described.
Example structure based on logical layers:
•	00_SystemOverview.docx
•	10_PresentationLayer.doc
•	20_ServicesLayer.docx
•	30_BatchProcessing.docx
•	40_IntegrationLayer.docx
•	50_PersistenceLayer.docx
•	….
Another example is project which requires heavier documentation for some of the views, for example “Development” and “Deployment” require detailed documentation. In that case the final documentation may be structured:
•	00_SystemOverview.docx
o	Context
o	Functional View
o	Process View
o	Non-functional View
o	Principles
o	Standards/Common Solutions
o	Logical View
o	…..
o	Verification
•	10_Development.docx
o	Context
o	Functional View
o	Process View
o	Non-functional View
o	Principles
o	Standards/Common Solutions
o	Logical View
o	…..
o	Verification
•	10_Deployment.docx
o	Context
o	Functional View
o	Process View
o	Non-functional View
o	Principles
o	Standards/Common Solutions
o	Logical View
o	…..
o	Verification

Sometimes it is convenient to create folders, for each part, especially when additional materials are included of individual chapters.
Final layout of documentation is dependent on agreed project structure and can be influenced by customer or project partners. However we strongly recommend using this structure for working versions.
Related Documents
•	Technology Architecture Documentation.template.docx – contains empty structure (document outline) for Views described in this document.
Conventions
TBD:




"
