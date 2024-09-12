// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

entitlement "Dynamics 365 Business Central Essentials"
{
    Type = PerUserServicePlan;
    Id = '920656a2-7dd8-4c83-97b6-a356414dbd36';

    ObjectEntitlements = "D365BCEssentials",
                         AllUIUserLicensePermissions;
}
