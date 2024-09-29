curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListCommon.xml http://localhost:8080/fhir/Library/WADAListCommon
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListS1.xml http://localhost:8080/fhir/Library/WADAListS1
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAListS2.xml http://localhost:8080/fhir/Library/WADAListS2
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/Library-WADAList.xml http://localhost:8080/fhir/Library/WADAList

curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S1-FEST.xml http://localhost:8080/fhir/ValueSet/S1-FEST
curl -X PUT -H "Content-Type: application/fhir+xml" -d@../input/vocabulary/ValueSet/ValueSet-S2-FEST.xml http://localhost:8080/fhir/ValueSet/S2-FEST

curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s1/MedicationKnowledge/MedicationKnowledge-Aranesp-inj-oppl-50-mikrog-sproyte.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s1/MedicationKnowledge/MedicationKnowledge-Aspirin-tab-500-mg.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s1/MedicationKnowledge/MedicationKnowledge-Intrarosa-vagitorie-6,5-mg.xml http://localhost:8080/fhir/MedicationKnowledge

curl -X PUT -H "Content-Type: application/fhir+xml" -d@../output/PlanDefinition-WADAList.xml http://localhost:8080/fhir/PlanDefinition/WADAList
