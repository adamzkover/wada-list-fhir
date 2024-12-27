Files in this directory can be used to test the Library $evaluate operation with the resources in the IG.

1. Build the IG with `_genonce.sh`, from the root directory of the repository
1. Start a HAPI FHIR server using `docker-compose.yml`
1. Upload resources to the server from the IG's `output` directory with `_upload.sh`
1. Upload example medication core data resources with `_upload-core.sh`
1. Send the example parameters to the Library's $evaluate operation with `_libEvaluate.sh`

The returned `<Parameters>` should have `issues` parameters with responses from groups S1 and S2.
