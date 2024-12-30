library WADAListS3 version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListCommon version '0.1.0' called WADAListCommon

valueset S3Vs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S3-FEST'
valueset S3AVs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S3A-FEST'
valueset S3BVs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S3B-FEST'
valueset S3CVs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S3C-FEST'
valueset S3DVs: 'https://folk.ntnu.no/adamzk/it6103/ValueSet/S3D-FEST'

define function GetIssues(Meds List<FHIR.Medication>):
  flatten({
    WADAListCommon.GetIssues(Meds, S3Vs,
      'S3', 'red', null,
      'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3'),
    WADAListCommon.GetIssues(Meds, S3AVs,
      'S3', 'yellow', 'Inhalert formoterol - maksimalt 54 mikrogram per 24 timer',
      'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3'),
    WADAListCommon.GetIssues(Meds, S3BVs,
      'S3', 'yellow', 'Inhalert salbutamol - maksimalt 1600 mikrogram per 24 timer fordelt på doser som til sammen ikke skal overskride 600 mikrogram i løpet av noen åttetimersperioder',
      'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3'),
    WADAListCommon.GetIssues(Meds, S3CVs,
      'S3', 'yellow', 'Inhalert salmeterol - maksimalt 200 mikrogram per 24 timer',
      'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3'),
    WADAListCommon.GetIssues(Meds, S3DVs,
      'S3', 'yellow', 'Inahlert vilanterol - maksimalt 25 mikrogram per 24 timer',
      'https://www.antidoping.no/medisinsk/dopinglisten/dopinggruppe-s3')
  })
