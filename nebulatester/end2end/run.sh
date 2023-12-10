#!/bin/bash

set -ex

# Create the project name since this is not one of the defaults
nebulakit_venv nebula-cli -h nebulaadmin:81 --insecure register-project -n nebulatester --identifier nebulatester -d "test_project" || true

### Need to get Nebula Admin to cluster sync this so that k8s resources are actually created ###
# Currently, kill the admin pod, so that the init container sync picks up the change.

# First register everything, but make sure to use local Dockernetes admin
nebulakit_venv pynebula -c end2end/end2end.config register -p nebulatester -d development workflows

# Kick off workflows
# This one needs an input, which is easier to do programmatically using nebulakit
nebulakit_venv pynebula -c end2end/end2end.config lp -p nebulatester -d development execute app.workflows.work.WorkflowWithIO --b hello_world

# Quick shortcut to get at the version
arrIN=(${NEBULA_INTERNAL_IMAGE//:/ })
VERSION=${arrIN[1]}

nebulactl --config /opt/go/config.yaml get launchplan -p nebulatester -d development app.workflows.failing_workflows.DivideByZeroWf --version ${VERSION} --execFile DivideByZeroWf.yaml
nebulactl --config /opt/go/config.yaml create execution --execFile DivideByZeroWf.yaml -p nebulatester -d development

nebulactl --config /opt/go/config.yaml get launchplan -p nebulatester -d development app.workflows.failing_workflows.RetrysWf --version ${VERSION} --execFile Retrys.yaml
nebulactl --config /opt/go/config.yaml create execution --execFile Retrys.yaml -p nebulatester -d development

nebulactl --config /opt/go/config.yaml get launchplan -p nebulatester -d development app.workflows.failing_workflows.FailingDynamicNodeWF --version ${VERSION} --execFile FailingDynamicNodeWF.yaml
nebulactl --config /opt/go/config.yaml create execution --execFile FailingDynamicNodeWF.yaml -p nebulatester -d development

nebulactl --config /opt/go/config.yaml get launchplan -p nebulatester -d development app.workflows.failing_workflows.RunToCompletionWF --version ${VERSION} --execFile RunToCompletionWF.yaml
nebulactl --config /opt/go/config.yaml create execution --execFile RunToCompletionWF.yaml -p nebulatester -d development

# Make sure workflow does everything correctly
nebulakit_venv python end2end/validator.py
