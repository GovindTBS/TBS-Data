// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

entitlement "Dynamics 365 for Team Members"
{
    Type = PerUserServicePlan;
    Id = 'd9a6391b-8970-4976-bd94-5f205007c8d8';

    ObjectEntitlements = "D365forTeamMembers",
                         AllUIUserLicensePermissions;
}
