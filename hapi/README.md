Files in this directory can be used to test the PlanDefinition $apply operation with the resources in the IG.

1. Start a HAPI FHIR server with `docker-compose.yml`
1. Upload resources to the server from the IG's `output` directory with `_upload.sh`
1. Send the `pd-apply-params.xml` payload to the $apply operation with `_pdApply.sh`

Depending on the content of `pd-apply-params.xml`, the returned `<CarePlan>` should have `<action>` elements for group S1, S2, or both.
