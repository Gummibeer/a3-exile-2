class CfgNetworkMessages
{
    class GetStoredVehiclesRequest
    {
        module = "VirtualGarage";
        parameters[] = {"STRING"};
    };

    class GetStoredVehiclesResponse
    {
        module = "VirtualGarage";
        parameters[] = {"ARRAY"};
    };

    class RetrieveVehicleRequest
    {
        module = "VirtualGarage";
        parameters[] = {"STRING"};
    };

    class RetrieveVehicleResponse
    {
        module = "VirtualGarage";
        parameters[] = {"STRING","STRING"};
    };

    class StoreVehicleRequest
    {
        module = "VirtualGarage";
        parameters[] = {"STRING","STRING"};
    };

    class StoreVehicleResponse
    {
        module = "VirtualGarage";
        parameters[] = {"STRING"};
    };
};
