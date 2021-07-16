. ./env.sh

cat > $SUBMISSION_DIR/$DIVISION/systems/LTechKorea-L4210S-10G.json <<EOF
{
    "division": "closed",
    "submitter": "LTechKorea",
    "status": "preview",
    "system_type":"datacenter",
    "system_name": "LTechKorea-L4210S-10G",

    "number_of_nodes": "1",
    "host_processor_model_name": "Intel Xeon Gold 6258R",
    "host_processors_per_node": "2",
    "host_processor_core_count": "56",
    "host_processor_frequency": "2.70GHz up to 4.00Ghz",
    "host_processor_caches": "38.5MB",
    "host_memory_configuration": "12 slots / 64GB each / 2933 MT/s per socket",
    "host_memory_capacity": "768GB",
    "host_storage_capacity": "",
    "host_storage_type": "Solid State Drive",
    "host_processor_interconnect": "",
    "host_networking": "",
    "host_networking_topology": "",

    "accelerators_per_node": "8",
    "accelerator_model_name": "NVIDIA Tesla V100S",
    "accelerator_frequency": "",
    "accelerator_host_interconnect": "",
    "accelerator_interconnect": "",
    "accelerator_interconnect_topology": "",
    "accelerator_memory_capacity": "32GB",
    "accelerator_memory_configuration": "",
    "accelerator_on-chip_memories": "",
    "cooling": "passive",
    "hw_notes": ""
}
EOF