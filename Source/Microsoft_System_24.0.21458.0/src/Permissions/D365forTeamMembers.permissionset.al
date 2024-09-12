// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

using System.Apps;
using System.Environment;
using System.Environment.Configuration;
using System.Integration;
using System.Reflection;
using System.Tooling;

permissionset 2000000018 D365forTeamMembers
{
    Assignable = false;
    IncludedPermissionSets = BaseSystemPermissionSet,
                             "Role Configuration - Read";
    Permissions = tabledata "All Profile" = RIMD,
                  tabledata "API Webhook Notification" = RIMD,
                  tabledata "API Webhook Notification Aggr" = RIMD,
                  tabledata "API Webhook Subscription" = RIMD,
                  tabledata Company = RiMd,
                  tabledata "Configuration Package File" = RiMd,
                  tabledata "Designed Query Group" = RM,
                  tabledata "Designed Query Permission" = RM,
                  tabledata "External Event Subscription" = RIMD,
                  tabledata "External Event Log Entry" = RIMD,
                  tabledata "External Event Notification" = RIMD,
                  tabledata "Feature Key" = RIMD,
                  tabledata "NAV App Installed App" = Rm,
                  tabledata "Published Application" = Rm,
                  tabledata "User Default Style Sheet" = RM,
                  tabledata "User Page Metadata" = RIMD,
                  tabledata "Webhook Notification" = RiMd;
}
