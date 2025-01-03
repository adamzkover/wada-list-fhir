library WADAListCommon version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

define function GetMedicationCodings(
    Medications List<FHIR.Medication>):
  distinct(
    flatten(
      Medications M
      return M.code.coding
    )
  )

define function GetMatchingMedication(
    MK MedicationKnowledge,
    Medications List<FHIR.Medication>):
  Medications M
  where Count(M.code.coding intersect MK.code.coding) > 0
  return M

define function GetMatchingIngredientDetails(
    MK MedicationKnowledge,
    VS System.ValueSet,
    GroupCode System.String,
    Severity System.String,
    Comment System.String):
  Combine(
    MK.ingredient Ing
    where Ing.item.coding in VS
    return Combine(Ing.item.coding.display)
  ) + ': ' + (
    case
      when Severity = 'red' then 'forbudt iht. WADAs dopingliste'
      when Severity = 'yellow' then 'forbudt iht. WADAs dopingliste, med visse unntak/restriksjoner'
      else 'Ukjent'
    end
  ) + ' (' + GroupCode + ')' + (
    case
      when Comment is not null then ' - ' + Comment
      else ''
    end
  )

define function GetMedicationRefs(
    Medications List<FHIR.Medication>):
  Medications M
  return Reference {
    reference: string { value: 'Medication/' + M.id }
  }

/*
define function GetIssues(
    Medications List<FHIR.Medication>,
    VS System.ValueSet,
    GroupCode String, Severity String, URL String):
  [MedicationKnowledge] MK
    let
      matchingCodes: MK.code.coding intersect GetMedicationCodings(Medications)
    where MK.ingredient.item.coding in VS and Count(matchingCodes) > 0
    return DetectedIssue {
      status: DetectedIssueStatus  { value: 'final' },
      implicated: GetMedicationRefs(GetMatchingMedication(MK, Medications)),
      detail: string { value: GetMatchingIngredients(MK, VS, GroupCode, Severity) },
      reference: uri { value: URL }
    }
*/

define function GetIssues(
    Medications List<FHIR.Medication>, MedicationKnowledges List<FHIR.MedicationKnowledge>, VS System.ValueSet,
    GroupCode String, Severity String, Comment String,
    URL String):
  MedicationKnowledges MK
    let
      matchingCodes: MK.code.coding intersect GetMedicationCodings(Medications)
    where MK.ingredient.item.coding in VS and Count(matchingCodes) > 0
    return DetectedIssue {
      status: DetectedIssueStatus  { value: 'final' },
      severity: DetectedIssueSeverity { value: (case
        when Severity = 'red' then 'high'
        when Severity = 'yellow' then 'moderate'
        else 'low'
      end)},
      implicated: GetMedicationRefs(GetMatchingMedication(MK, Medications)),
      detail: string { value: GetMatchingIngredientDetails(MK, VS, GroupCode, Severity, Comment) },
      reference: uri { value: URL }
    }
