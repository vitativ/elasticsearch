import testinfra


def test_service_is_running_and_enabled(Service):
    kibana = Service('kibana')
    assert kibana.is_running
    assert kibana.is_enabled
