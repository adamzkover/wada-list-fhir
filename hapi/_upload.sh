curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListCommon.xml http://localhost:8080/fhir/Library/WADAListCommon
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListS1.xml http://localhost:8080/fhir/Library/WADAListS1
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListS2.xml http://localhost:8080/fhir/Library/WADAListS2
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListS3.xml http://localhost:8080/fhir/Library/WADAListS3
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAList.xml http://localhost:8080/fhir/Library/WADAList

curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S1-FEST.xml http://localhost:8080/fhir/ValueSet/S1-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S2-FEST.xml http://localhost:8080/fhir/ValueSet/S2-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S3-FEST.xml http://localhost:8080/fhir/ValueSet/S3-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S3A-FEST.xml http://localhost:8080/fhir/ValueSet/S3A-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S3B-FEST.xml http://localhost:8080/fhir/ValueSet/S3B-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S3C-FEST.xml http://localhost:8080/fhir/ValueSet/S3C-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S3D-FEST.xml http://localhost:8080/fhir/ValueSet/S3D-FEST
