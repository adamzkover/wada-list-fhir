library WADAList version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListS1 version '0.1.0' called WADAListS1
include WADAListS2 version '0.1.0' called WADAListS2
include WADAListS3 version '0.1.0' called WADAListS3

define "medications":
  [Medication] M
  return M

define function getMedicationFhirCodings(Medications List<Medication>):
  flatten(
  [Medication] M
  return M.code.coding)

define function getMedicationSystemCodings(Codes List<Code>):
  Codes fhirCode
  return System.Code {
    system: fhirCode.system,
    code: fhirCode.code,
    display: fhirCode.display
  }

define "medicationKnowledges":
  [MedicationKnowledge: code.coding in getMedicationSystemCodings(getMedicationFhirCodings("medications"))] MK
  return MK

define "issues":
  flatten {
    WADAListS1.GetIssues("medications", "medicationKnowledges"),
    WADAListS2.GetIssues("medications", "medicationKnowledges"),
    WADAListS3.GetIssues("medications", "medicationKnowledges")
  }
