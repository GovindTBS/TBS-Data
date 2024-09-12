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

permissionset 2000000023 M365Collaboration
{
    Assignable = false;
    IncludedPermissionSets = BaseSystemPermissionSet,
                             "Role Configuration - Read";
    Permissions = tabledata "All Profile" = RIMD,
                  tabledata "API Webhook Notification" = Rimd,
                  tabledata "API Webhook Notification Aggr" = Rimd,
                  tabledata "API Webhook Subscription" = Rimd,
                  tabledata Company = Rimd,
                  tabledata "Configuration Package File" = Rimd,
                  tabledata "Designed Query Group" = R,
                  tabledata "Designed Query Permission" = R,
                  tabledata "External Event Subscription" = RIMD,
                  tabledata "External Event Log Entry" = RIMD,
                  tabledata "External Event Notification" = RIMD,
                  tabledata "Feature Key" = RIMD,
                  tabledata "NAV App Installed App" = R,
                  tabledata "Published Application" = R,
                  tabledata "User Default Style Sheet" = R,
                  tabledata "User Page Metadata" = Rimd,
                  tabledata "Webhook Notification" = Rimd;
}