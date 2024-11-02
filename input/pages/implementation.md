This is a proof of concept implementation of the WADA List of Prohibited Substances and Methods as computable knowledge representation, using the HL7 standards [CQL](https://cql.hl7.org/) and [FHIR (R4)](https://hl7.org/fhir/R4/). The computable guidelines are implemented as an HL7 FHIR content implementation guide, following the resource layout of the [Content IG Walkthrough](https://github.com/cqframework/content-ig-walkthrough).

The implementation is limited to a subset of the List, and medicinal products on the Norwegian market. Substances that are not active ingredients in any approved medicinal product in Norway are out of scope. Statements like *"og andre stoffer med lignende kjemisk struktur eller lignende biologisk(e) effekt(er)"* are only evaluated in the scope of medicinal products approved in Norway.

Groups in scope for the implementation:

* [S1. Anabole stoffer](https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s1)

The implementation uses medicinal product core data and substance codes from the Norwegian Electronic Prescription Support System (FEST) from the Norwegian Medical Products Agency (NOMA).

The figure below illustrates the scope and components of the implementation guide, and its role in a larger decision support system. The organizational roles represented in the figure build on a model of cooperative authoring, between Anti-Doping Norway (ADNO), the Norwegian WADA affiliate, and Felleskatalogen (FK), the Norwegian Pharmaceutical Product Compendium.

<p style="text-align: center">
<img src="WADA-List-CDS.png" style="margin: 0 auto; float: none;"/>
</p>

The knowledge base of the implementation guide consists of PlanDefinition, Library, and ValueSet resources.

* PlanDefinition: wrapper element with metadata, refers to the Library
* Library: contains the clinical logic of the guidelines (CQL), reads ValueSets and external MedicationKnowledge resources
* ValueSet: defines a selection of substances to wich particular guidelines apply

The ValueSets and guideline logic Libraries make use of resources not contained in the implementation guide:

* MedicationKnowledge: representation of a medicinal product, registers the identifier and the ingredients
* CodeSystem: declares the existence of substances and assigns identifiers to them; ValueSets select codes from a CodeSystem

See the profiles and examples in the [Artifacts Summary](artifacts.html) for more details on these resources.

### Execution

Systems interact with the guidelines through the `PlanDefinition/$apply` operation. See definitions of the operation in [the FHIR specification](https://hl7.org/fhir/R4/plandefinition-operation-apply.html) and [the HAPI FHIR library](https://hapifhir.io/hapi-fhir/docs/clinical_reasoning/plan_definitions.html#apply).

#### Query

The operation input is a Parameters resource with the parameters `subject` (patient reference, string) and `data` (Bundle of Medication resources).

The Medication resources sent by the user contain the medication identifiers only. Ingredients are extracted by the clinical logic from the MedicationKnowledge resources that are matched by the input identifiers.

**Extension:** Allow the input to contain MedicationAdministration (MA), MedicationRequest (MR), and MedicationStatement (MS) resources. These resources can refer to a Medication, and in addition contain information about dose form, route of administration, dose, and a timestamp.

#### Evaluation

A single PlanDefinition and a single wrapper Library are the entry point of the evaluation logic. The guidelines consist of several groups, each can be represented and evaluated against independently. The wrapper Library calls the Library of each of the doping groups. When possible, clinical logic is extracted to support libraries that are shared between the individual group libraries.

The knowledge base of a guideline group comprises a substance list (the list of forbidden substances), the search and matching logic (shareable across groups), and any additional restrictions and comments on some of the substances.

##### Substances

Central to each group is the definition of a list of substances. S-groups and P1 define a set of substances that are forbidden. The list of substances is a non-exhaustive list, but can be made finite when the scope is restricted to approved medicinal products.

The set of substances can be represented with a ValueSet of coded values, in turn recorded in a CodeSystem. ValueSets can be nested to represent subgroups and build up a complete substance list that represents a group. For the definition of the code systems and value sets, see [the terminology page](terminology.html).

##### Logic

The evaluation logic can be expressed with CQL. The logic consists of the following steps:

* Extract data from query (medication identifier, dose form or route of administration, dose)
* Compare substance to the group’s substance list
* Optionally evaluate other data elements, if available in the input and indicated by the substance group definition

Based on the medication identifiers in the input, the ingredients are looked up in the matching MedicationKnowledge core data resources of the knowledge base. The evaluation logic checks if the same code appears in any of the ValueSets associated with the guideline group.

**Extension:** When indicated by the matching ValueSet, other properties of the MA/MR/MS can also be evaluated (e.g., for S3: *formoterol: maksimalt 54 mikrogram per 24 timer*). This can be coded as part of the CQL definition. Dose form or route of administration, and dose can be extracted from these resources, and compared to values stored either in the CQL code, or, in case of coded values, similarly to substances, in separately defined ValueSets.

#### Response

The return values of each group Library are aggregated by the wrapper Library and returned according to the definitions in the PlanDefinition, made available in the response in the `action` field of the returned CarePlan resource.
