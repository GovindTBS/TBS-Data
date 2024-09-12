// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

entitlement "Dynamics 365 Business Central Team Member - Embedded"
{
    Type = PerUserServicePlan;
    Id = 'fd1441b8-116b-4fa7-836e-d7956700e0fa';

    ObjectEntitlements = D365BCTeamMemberEmbedded,
                         AllUIUserLicensePermissions;
}
