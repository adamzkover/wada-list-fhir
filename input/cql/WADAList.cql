library WADAList version '0.1.0'
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers

include WADAListS1 version '0.1.0' called WADAListS1
include WADAListS2 version '0.1.0' called WADAListS2
include WADAListS3 version '0.1.0' called WADAListS3

define "medications":
  [Medication] M
  return M

define "issues":
  flatten {
    WADAListS1.GetIssues("medications"),
    WADAListS2.GetIssues("medications"),
    WADAListS3.GetIssues("medications")
  }
