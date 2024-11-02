library WADAListCommon version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

define function GetMedicationCodings(Medications List<FHIR.Medication>):
  distinct(
    flatten(
      Medications M
      return M.code.coding
    )
  )

define function GetMatchingMedKnowledges(VS System.ValueSet, MedicationCodes List<FHIR.Coding>):
  [MedicationKnowledge] MK
  where MK.ingredient.item.coding in VS and (Count(MK.code.coding intersect MedicationCodes) > 0)
  return MK

define function GetMatchingIngredients(MK MedicationKnowledge, VS System.ValueSet, Kategori System.String, Severity System.String):
  MK.code.text + ': ' +
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
  ) + ' (' + Kategori + ')'

define function GetMatchingIngredientsForList(MKList List<MedicationKnowledge>, VS System.ValueSet, Kategori System.String, Severity System.String):
  Combine(
    (MKList MK
    return GetMatchingIngredients(MK, VS, Kategori, Severity)), '; '
  )

define function GetCard(
    Medications List<FHIR.Medication>, VS System.ValueSet,
    Kategori String, Severity String):
    GetMatchingIngredientsForList(GetMatchingMedKnowledges(VS, GetMedicationCodings(Medications)), VS, Kategori, Severity)
