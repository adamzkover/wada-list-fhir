curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s1/MedicationKnowledge/MedicationKnowledge-Aspirin.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s1/MedicationKnowledge/MedicationKnowledge-Intrarosa.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s2/MedicationKnowledge/MedicationKnowledge-Aranesp.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s3/MedicationKnowledge/MedicationKnowledge-Berotec-N.xml http://localhost:8080/fhir/MedicationKnowledge
curl -X POST -H "Content-Type: application/fhir+xml" -d@../input/tests/WADAList/test-s3/MedicationKnowledge/MedicationKnowledge-Symbicort-Turbuhaler.xml http://localhost:8080/fhir/MedicationKnowledge
