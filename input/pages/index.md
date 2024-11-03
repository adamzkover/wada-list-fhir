### Background

**WADA**, the World Anti Doping Agency publishes **guidelines** on the use of medicines: "The List of Prohibited Substances and Methods (List) indicates **what substances and methods are prohibited in sport and when**." The guidelines are published as human-readable text on the websites of WADA and its affiliated national organizations.

This content implementation guide is a **proof of concept implementation** of the WADA List of Prohibited Substances and Methods as **computable knowledge representation**, upgrading the guidelines, using the terminology from ["A multilayered framework for representing clinical decisions"]( https://academic.oup.com/jamia/article/18/Supplement_1/i132/797073), **from Unstructured to Executable** content.

The implementation uses the HL7 standards [Clinical Quality Language (CQL)](https://cql.hl7.org/) and [Fast Health Interoperability Resources (FHIR) Release 4 (R4)](https://hl7.org/fhir/R4/), following the resource layout of the [Content IG Walkthrough](https://github.com/cqframework/content-ig-walkthrough).

An example of such a computable guideline representation is the [WHO Antenatal Care Guideline Implementation Guide](https://build.fhir.org/ig/WorldHealthOrganization/smart-anc/index.html).

Benefits of a computable guideline representation include the ability to evaluate new products automatically, and the possibility to build clinical decision support services on the knowledge base represented by the gudeline's resources.

See the [Implementation](implementation.html) page for technical details of the implementation.

### Disclaimer

This content is developed as an exam submission for the course IT, Organization and Cooperation in Healthcare (IT6103) at the Norwegian University of Science and Technology (NTNU). Its sole purpose is to demonstrate the feasibility of the technological solution and should not be used to inform any real-life decisions.
