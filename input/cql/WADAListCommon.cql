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

define function GetCard(
    Medications List<FHIR.Medication>, VS System.ValueSet,
    Tittel String, Kategori String):
    {
        "Tittel": Tittel,
        "Kategori": Kategori,
        "Match": (Count(GetMatchingMedKnowledges(VS, GetMedicationCodings(Medications))) > 0),
        "MedicationKnowledges": GetMatchingMedKnowledges(VS, GetMedicationCodings(Medications))
    }
