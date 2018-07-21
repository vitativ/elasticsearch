import testinfra


def test_package_in_installed(Package):
    kibana = Package('kibana')
    assert kibana.is_installed
    assert kibana.version.startswith('5.')

def test_service_is_running_and_enabled(Service):
    kibana = Service('kibana')
    assert kibana.is_running
    assert kibana.is_enabled
