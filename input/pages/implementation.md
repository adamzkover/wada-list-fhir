### Implementation scope

The implementation is limited to a subset of the List, and medicinal products on the Norwegian market. Substances that are not active ingredients in any approved medicinal product in Norway are out of scope. Statements like *"og andre stoffer med lignende kjemisk struktur eller lignende biologisk(e) effekt(er)"* are only evaluated in the scope of medicinal products approved in Norway.

Groups in scope for the implementation:

* [S1. Anabole stoffer](https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s1)
* [S2. Peptidhormoner, vekstfaktorer, relaterte stoffer og mimetika](https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s2)
* [S3. Beta-2-agonister](https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3)

The implementation uses medicinal product core data and substance codes from the Norwegian [Electronic Prescription Support System (FEST)](https://www.dmp.no/en/about-us/distribution-of-data-on-medicinal-products/electronic-prescription-support-system-fest) from the Norwegian Medical Products Agency (NOMA). For a discussion of the role of terminology and using different code systems, see [the terminology page](terminology.html).

### CDS Architecture

The figure below illustrates the components of the implementation guide, and its role in a larger decision support system. The organizational roles represented in the figure build on a model of cooperative authoring, between Anti-Doping Norway (ADNO), the Norwegian WADA affiliate, and Felleskatalogen (FK), the Norwegian Pharmaceutical Product Compendium.

<p style="text-align: center">
<img src="WADA-List-CDS.png" style="margin: 0 auto; float: none;"/>
</p>

The knowledge base of the implementation guide consists of PlanDefinition, Library, and ValueSet resources.

* PlanDefinition: wrapper element with metadata, refers to the Library
* Library: contains the clinical logic of the guidelines (CQL), processes the user input and reads ValueSets and external MedicationKnowledge resources
* ValueSet: defines a selection of substances to wich particular guidelines apply

The ValueSets and guideline logic Libraries make use of resources not contained in the implementation guide:

* MedicationKnowledge: representation of a medicinal product, registers the product identifiers and the coded ingredients
* CodeSystem: declares the existence of substances and assigns identifiers to them; ValueSets select codes from a CodeSystem

See the profiles and examples in the [Artifacts Summary](artifacts.html) for more details on these resources.

### CDS Service API

The resources of the implementation guide can be uploaded to a compatible FHIR server (e.g., a [CQF Ruler](https://github.com/cqframework/cqf-ruler) successor, [HAPI FHIR](https://github.com/hapifhir/hapi-fhir-jpaserver-starter)) to provide a clinical decision support API.

Client systems interact with the guidelines through the `PlanDefinition/$apply` operation. See definitions of the operation in [the FHIR specification](https://hl7.org/fhir/R4/plandefinition-operation-apply.html) and [the HAPI FHIR library](https://hapifhir.io/hapi-fhir/docs/clinical_reasoning/plan_definitions.html#apply).

#### User input

The operation input is a Parameters resource with the parameters `subject` (patient reference, string) and `data` (Bundle of Medication resources).

The Medication resources sent by the user contain the medication identifiers only. Ingredients are extracted by the clinical logic from the MedicationKnowledge resources that are matched by the input identifiers.

**Extension:** Allow the input to contain MedicationAdministration (MA), MedicationRequest (MR), and MedicationStatement (MS) resources. These resources can refer to a Medication, and in addition contain information about dose form, route of administration, dose, and a timestamp.

#### Request processing

A single PlanDefinition and a single wrapper Library it refers to are the entry point of the evaluation logic. The guidelines consist of several groups, each can be represented and evaluated against independently. The wrapper Library calls the Library of each of the doping groups. When possible, clinical logic is extracted to support libraries that are shared between the individual group libraries.

The knowledge base of a guideline group comprises a substance list (the list of forbidden substances), the search and matching logic (shareable across groups), and any additional restrictions and comments on some of the substances.

##### Substance lists

Central to each group is the definition of a list of substances. S-groups and P1 define a set of substances that are forbidden. The list of substances is a non-exhaustive list, but can be made finite when the scope is restricted to approved medicinal products.

The set of substances are represented as a ValueSet of coded values, in turn recorded in a CodeSystem. ValueSets can be nested to represent subgroups and build up a complete substance list that represents a group.

##### Evaluation logic

The evaluation logic can be expressed with CQL, wrapped in a Libraray. The logic consists of the following steps:

* Extract data from query (medication identifier, dose form or route of administration, dose)
* Match medication identifiers to the knowledge base and get the ingredients of each medication
* Compare the medications' ingredients to the group’s substance list
* Optionally evaluate other data elements, if available in the input and indicated by the substance group definition
* Return an appropriate warning when a match is found

Based on the medication identifiers in the input, the ingredients are looked up in the matching MedicationKnowledge core data resources of the knowledge base. The evaluation logic checks if the same code appears in any of the ValueSets associated with the guideline group.

**Extension:** When indicated by the matching ValueSet, other properties of the MA/MR/MS can also be evaluated (e.g., for S3: *formoterol: maksimalt 54 mikrogram per 24 timer*). This can be coded as part of the CQL definition. Dose form or route of administration, and dose can be extracted from these resources, and compared to values stored either in the CQL code, or, in case of coded values, similarly to substances, in separately defined ValueSets.

#### Response

The return values of each group Library are aggregated by the wrapper Library and returned according to the definitions in the PlanDefinition, made available in the response in the `action` field of the returned CarePlan resource.

#### Examples

Example configuration for running a HAPI FHIR server is in the `hapi` directory of the implementation guide's repository on GitHub. Scripts for uploading resources from the implementation guide and querying the service are provided in the same directory.

Sample knowledge base resources are available as part of the test cases in the `input/tests` directory.
