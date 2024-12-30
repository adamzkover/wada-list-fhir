library WADAListS2 version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListCommon version '0.1.0' called WADAListCommon

valueset S2Vs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S2-FEST'

define function GetIssues(Meds List<FHIR.Medication>):
  WADAListCommon.GetIssues(Meds, S2Vs,
    'S2', 'red', null,
    'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s2')
