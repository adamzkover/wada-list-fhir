library WADAList version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListS1 version '0.1.0' called WADAListS1
include WADAListS2 version '0.1.0' called WADAListS2

context Patient

define private Meds:
  [Medication] M
  return M

define private Cards:
  ({
    WADAListS1.GetCard(Meds),
    WADAListS2.GetCard(Meds)
  }) C where C != ''
  return C

define public HasMatch:
  Count(Cards) > 0

define public MatchingIngredientDetails:
  Combine(Cards, '; ')
