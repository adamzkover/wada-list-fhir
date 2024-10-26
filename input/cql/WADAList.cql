library WADAList version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListS1 version '0.1.0' called WADAListS1
include WADAListS2 version '0.1.0' called WADAListS2

context Patient

define function CardDetails(Card Tuple {
    "Tittel" String,
    "Kategori" String,
    "Match" Boolean,
    "MedicationKnowledges" List<FHIR.MedicationKnowledge>,
    "Message" String}):
  'Medisiner: ' & Card.Message

define Meds:
  [Medication] M
  return M

define public Cards:
  Tuple {
    S1: WADAListS1.GetCard(Meds),
    S2: WADAListS2.GetCard(Meds)
  }

define S1Match:
  "Cards"."S1"."Match"
define S2Match:
  "Cards"."S2"."Match"

define S1MatchingMedicationNames:
  CardDetails("Cards"."S1")

define S2MatchingMedicationNames:
  CardDetails("Cards"."S2")
