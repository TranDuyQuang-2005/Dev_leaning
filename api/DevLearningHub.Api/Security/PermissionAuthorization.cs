using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;

namespace DevLearningHub.Api.Security;

public sealed class RequirePermissionAttribute : AuthorizeAttribute
{
    public RequirePermissionAttribute(params string[] permissions)
        => Policy = PermissionPolicyProvider.PolicyPrefix + string.Join("|", permissions);
}

public sealed class PermissionRequirement : IAuthorizationRequirement
{
    public PermissionRequirement(IEnumerable<string> permissions)
        => Permissions = permissions.Where(x => !string.IsNullOrWhiteSpace(x)).Select(x => x.Trim()).ToArray();

    public IReadOnlyCollection<string> Permissions { get; }
}

public sealed class PermissionAuthorizationHandler : AuthorizationHandler<PermissionRequirement>
{
    protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, PermissionRequirement requirement)
    {
        var roles = context.User.FindAll(ClaimTypes.Role).Select(x => x.Value);
        if (roles.Any(x => x.Equals("Admin", StringComparison.OrdinalIgnoreCase)))
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        var permissions = context.User.FindAll("permission").Select(x => x.Value);
        if (permissions.Any(p => requirement.Permissions.Any(required => p.Equals(required, StringComparison.OrdinalIgnoreCase))))
            context.Succeed(requirement);

        return Task.CompletedTask;
    }
}

public sealed class PermissionPolicyProvider : DefaultAuthorizationPolicyProvider
{
    public const string PolicyPrefix = "Permission:";

    public PermissionPolicyProvider(IOptions<AuthorizationOptions> options)
        : base(options)
    {
    }

    public override Task<AuthorizationPolicy?> GetPolicyAsync(string policyName)
    {
        if (policyName.StartsWith(PolicyPrefix, StringComparison.OrdinalIgnoreCase))
        {
            var permissions = policyName[PolicyPrefix.Length..]
                .Split(new[] { '|', ',' }, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            var policy = new AuthorizationPolicyBuilder()
                .RequireAuthenticatedUser()
                .AddRequirements(new PermissionRequirement(permissions))
                .Build();

            return Task.FromResult<AuthorizationPolicy?>(policy);
        }

        return base.GetPolicyAsync(policyName);
    }
}
