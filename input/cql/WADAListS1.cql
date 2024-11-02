library WADAListS1 version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListCommon version '0.1.0' called WADAListCommon

valueset S1Vs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S1-FEST'

define function GetCard(Meds List<FHIR.Medication>):
  WADAListCommon.GetCard(Meds, S1Vs,
    's1', 'red')
  // Combine several Strings by invoking WADAListCommon.GetCard with a different ValueSet and Severity;
  // Append applicable comments/restrictions to each String
