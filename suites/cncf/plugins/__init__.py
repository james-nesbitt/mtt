from typing import Any

from mirantis.testing.metta.plugin import Factory, Type
from mirantis.testing.metta.environment import Environment

from .sonobuoy import SonobuoyWorkloadPlugin, METTA_PLUGIN_ID_SONOBUOY_WORKLOAD, SONOBUOY_WORKLOAD_CONFIG_LABEL, SONOBUOY_WORKLOAD_CONFIG_BASE
from .cli import SonobuoyCliPlugin, METTA_PLUGIN_ID_SONOBUOY_cli

@Factory(type=Type.WORKLOAD,
         plugin_id=METTA_PLUGIN_ID_SONOBUOY_WORKLOAD)
def metta_plugin_factory_workload_sonobuoy(
        environment: Environment, instance_id: str = '', label: str = SONOBUOY_WORKLOAD_CONFIG_LABEL, base: Any = SONOBUOY_WORKLOAD_CONFIG_BASE):
    """ create an metta kubernetes spec workload plugin """
    return SonobuoyWorkloadPlugin(
        environment, instance_id, label=label, base=base)


@Factory(type=Type.CLI, plugin_id=METTA_PLUGIN_ID_SONOBUOY_cli)
def metta_plugin_factory_cli_sonobuoy(
        environment: Environment, instance_id: str = ''):
    """ create an sonobuoy cli plugin """
    return SonobuoyCliPlugin(environment, instance_id)
