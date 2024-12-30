const requestEditor = CodeMirror.fromTextArea(document.getElementById("editor"), {
    lineNumbers: true,
    mode: "application/xml",
    theme: "eclipse"
});

const responseEditor = CodeMirror.fromTextArea(document.getElementById("response"), {
    lineNumbers: true,
    mode: "application/xml",
    theme: "eclipse",
    readOnly: true
});

function parseResponse(xmlString) {

    const $xmlDoc = $($.parseXML(xmlString));
    const medications = {};
    const issues = [];

    $xmlDoc.find("parameter").each(function () {
        const $parameter = $(this);
        const paramName = $parameter.find("name").attr("value");
        if (paramName === "medications") {
            const $medicationResource = $parameter.find("resource > Medication");
            const id = $medicationResource.find("id").attr("value");
            const medication = {
                id: id,
                issues: []
            }
            const $coding = $medicationResource.find("code > coding").first();
            if ($coding.length) {
                medication.system = $coding.find("system").attr("value");
                medication.code = $coding.find("code").attr("value");
                medication.display = $coding.find("display").attr("value");
            }
            medications[id] = medication;
        } else if (paramName === "issues") {
            const $detectedIssueResource = $parameter.find("resource > DetectedIssue");
            const medicationReference = $detectedIssueResource.find("implicated > reference").attr("value");
            const medicationId = medicationReference ? medicationReference.split("/")[1] : null;
            if (medicationId) {
                const issue = {
                    severity: $detectedIssueResource.find("severity").attr("value"),
                    medicationId: medicationId,
                    detail: $detectedIssueResource.find("detail").attr("value"),
                    reference: $detectedIssueResource.find("reference").not("implicated > reference").attr("value")
                }
                issues.push(issue);
            }
        }
    });

    issues.forEach(function (issue) {
        medications[issue.medicationId].issues.push(issue);
    });

    let extractedContent = "<h2>Detected Issues</h2>";
    $.each(medications, function (id, medication) {
        extractedContent += `<div class="card mb-3"><div class="card-header"><h3 class="mb-0">${medication.display || "Unknown Medication"}<br/></h3></div><div class="card-body"><small>ID: ${medication.id}</small>`;
        if (medication.issues.length > 0) {
            medication.issues.forEach(function (issue) {
                // Set alert color based on severity
                let alertColor = "info";
                if (issue.severity === "high") {
                    alertColor = "danger";
                } else if (issue.severity === "moderate") {
                    alertColor = "warning";
                }
                extractedContent += `<div class="alert alert-${alertColor}"><b>${issue.detail || "No detail available"}</b><br/>`;
                if (issue.reference) {
                    extractedContent += ` (<a class="alert-link" href="${issue.reference}" target="_blank">Reference</a>)`;
                } else {
                    extractedContent += ` (Reference: N/A)`;
                }
                extractedContent += `</div>`;
            });
        } else {
            extractedContent += "<p>No issues found for this medication.</p>";
        }
        extractedContent += "</div></div>";
    });
    $("#extractedContent").html(extractedContent);

}

function loadDefaultRequest() {
    $.ajax({
        url: "sample-input.xml",
        type: "GET",
        dataType: "text",
        async: false,
        success: function(response) {
            requestEditor.setValue(response);
        },
        error: function(xhr, status, error) {
            console.error("Error fetching the XML file:", status, error);
        }
    });
}

$(document).ready(function () {

    loadDefaultRequest();

    $("#sendRequestButton").click(function () {
        const xmlRequest = requestEditor.getValue();
        $.ajax({
            url: "http://localhost:8080/fhir/Library/WADAList/$evaluate",
            type: "POST",
            headers: {
                "Content-Type": "application/fhir+xml"
            },
            data: xmlRequest,
            dataType: "text",
            success: function (response) {
                responseEditor.setValue(response);
                parseResponse(response);
            },
            error: function (xhr) {
                console.error("Error sending request:", xhr.statusText);
                responseEditor.setValue(`Error: ${xhr.statusText}`);
            }
        });
    });

    $("#resetEditorButton").click(function () {
        loadDefaultRequest();
        responseEditor.setValue("");
        $("#extractedContent").html("");
    });

});
