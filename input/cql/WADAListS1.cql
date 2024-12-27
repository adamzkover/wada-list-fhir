library WADAListS1 version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListCommon version '0.1.0' called WADAListCommon

valueset S1Vs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S1-FEST'

define function GetIssues(Meds List<FHIR.Medication>):
  WADAListCommon.GetIssues(Meds, S1Vs,
    'S1', 'red', 'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s1')
