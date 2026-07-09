using System;
using DevLearningHub.Api.Data;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DevLearningHub.Api.Migrations;

[DbContext(typeof(DevLearningHubDbContext))]
[Migration("20260709070000_ExistingDatabase_AddPermissionGroupsAndPersonalPractice")]
public partial class ExistingDatabase_AddPermissionGroupsAndPersonalPractice : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "PermissionGroups",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                Name = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                Code = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                IsSystem = table.Column<bool>(type: "bit", nullable: false),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                IsDeleted = table.Column<bool>(type: "bit", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PermissionGroups", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "PersonalQuestionBanks",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                UserId = table.Column<long>(type: "bigint", nullable: false),
                Title = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                OriginalFileName = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                FileStorageKey = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                QuestionCount = table.Column<int>(type: "int", nullable: false),
                Visibility = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                IsDeleted = table.Column<bool>(type: "bit", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PersonalQuestionBanks", x => x.Id);
                table.ForeignKey(
                    name: "FK_PersonalQuestionBanks_Users_UserId",
                    column: x => x.UserId,
                    principalTable: "Users",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PermissionGroupPermissions",
            columns: table => new
            {
                PermissionGroupId = table.Column<long>(type: "bigint", nullable: false),
                PermissionId = table.Column<long>(type: "bigint", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PermissionGroupPermissions", x => new { x.PermissionGroupId, x.PermissionId });
                table.ForeignKey(
                    name: "FK_PermissionGroupPermissions_PermissionGroups_PermissionGroupId",
                    column: x => x.PermissionGroupId,
                    principalTable: "PermissionGroups",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_PermissionGroupPermissions_Permissions_PermissionId",
                    column: x => x.PermissionId,
                    principalTable: "Permissions",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "RolePermissionGroups",
            columns: table => new
            {
                RoleId = table.Column<long>(type: "bigint", nullable: false),
                PermissionGroupId = table.Column<long>(type: "bigint", nullable: false),
                AssignedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                AssignedBy = table.Column<long>(type: "bigint", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_RolePermissionGroups", x => new { x.RoleId, x.PermissionGroupId });
                table.ForeignKey(
                    name: "FK_RolePermissionGroups_PermissionGroups_PermissionGroupId",
                    column: x => x.PermissionGroupId,
                    principalTable: "PermissionGroups",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_RolePermissionGroups_Roles_RoleId",
                    column: x => x.RoleId,
                    principalTable: "Roles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "UserPermissionGroups",
            columns: table => new
            {
                UserId = table.Column<long>(type: "bigint", nullable: false),
                PermissionGroupId = table.Column<long>(type: "bigint", nullable: false),
                AssignedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                AssignedBy = table.Column<long>(type: "bigint", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_UserPermissionGroups", x => new { x.UserId, x.PermissionGroupId });
                table.ForeignKey(
                    name: "FK_UserPermissionGroups_PermissionGroups_PermissionGroupId",
                    column: x => x.PermissionGroupId,
                    principalTable: "PermissionGroups",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_UserPermissionGroups_Users_UserId",
                    column: x => x.UserId,
                    principalTable: "Users",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "PersonalPracticeAttempts",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                UserId = table.Column<long>(type: "bigint", nullable: false),
                BankId = table.Column<long>(type: "bigint", nullable: false),
                StartedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                Score = table.Column<decimal>(type: "decimal(6,2)", nullable: false),
                TotalQuestions = table.Column<int>(type: "int", nullable: false),
                CorrectCount = table.Column<int>(type: "int", nullable: false),
                Status = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PersonalPracticeAttempts", x => x.Id);
                table.ForeignKey(
                    name: "FK_PersonalPracticeAttempts_PersonalQuestionBanks_BankId",
                    column: x => x.BankId,
                    principalTable: "PersonalQuestionBanks",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PersonalQuestions",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                BankId = table.Column<long>(type: "bigint", nullable: false),
                UserId = table.Column<long>(type: "bigint", nullable: false),
                QuestionText = table.Column<string>(type: "nvarchar(max)", nullable: false),
                QuestionType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                Difficulty = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                Explanation = table.Column<string>(type: "nvarchar(max)", nullable: true),
                Tags = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                IsDeleted = table.Column<bool>(type: "bit", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PersonalQuestions", x => x.Id);
                table.ForeignKey(
                    name: "FK_PersonalQuestions_PersonalQuestionBanks_BankId",
                    column: x => x.BankId,
                    principalTable: "PersonalQuestionBanks",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "PersonalPracticeAttemptAnswers",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                AttemptId = table.Column<long>(type: "bigint", nullable: false),
                QuestionId = table.Column<long>(type: "bigint", nullable: false),
                SelectedOptionLabel = table.Column<string>(type: "nvarchar(5)", maxLength: 5, nullable: true),
                IsCorrect = table.Column<bool>(type: "bit", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PersonalPracticeAttemptAnswers", x => x.Id);
                table.ForeignKey(
                    name: "FK_PersonalPracticeAttemptAnswers_PersonalPracticeAttempts_AttemptId",
                    column: x => x.AttemptId,
                    principalTable: "PersonalPracticeAttempts",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_PersonalPracticeAttemptAnswers_PersonalQuestions_QuestionId",
                    column: x => x.QuestionId,
                    principalTable: "PersonalQuestions",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PersonalQuestionOptions",
            columns: table => new
            {
                Id = table.Column<long>(type: "bigint", nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                QuestionId = table.Column<long>(type: "bigint", nullable: false),
                Label = table.Column<string>(type: "nvarchar(5)", maxLength: 5, nullable: false),
                Text = table.Column<string>(type: "nvarchar(max)", nullable: false),
                IsCorrect = table.Column<bool>(type: "bit", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PersonalQuestionOptions", x => x.Id);
                table.ForeignKey(
                    name: "FK_PersonalQuestionOptions_PersonalQuestions_QuestionId",
                    column: x => x.QuestionId,
                    principalTable: "PersonalQuestions",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_PermissionGroups_Code",
            table: "PermissionGroups",
            column: "Code",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_PermissionGroupPermissions_PermissionId",
            table: "PermissionGroupPermissions",
            column: "PermissionId");

        migrationBuilder.CreateIndex(
            name: "IX_RolePermissionGroups_PermissionGroupId",
            table: "RolePermissionGroups",
            column: "PermissionGroupId");

        migrationBuilder.CreateIndex(
            name: "IX_UserPermissionGroups_PermissionGroupId",
            table: "UserPermissionGroups",
            column: "PermissionGroupId");

        migrationBuilder.CreateIndex(
            name: "IX_PersonalQuestionBanks_UserId_IsDeleted",
            table: "PersonalQuestionBanks",
            columns: new[] { "UserId", "IsDeleted" });

        migrationBuilder.CreateIndex(
            name: "IX_PersonalPracticeAttempts_BankId",
            table: "PersonalPracticeAttempts",
            column: "BankId");

        migrationBuilder.CreateIndex(
            name: "IX_PersonalPracticeAttempts_UserId_BankId",
            table: "PersonalPracticeAttempts",
            columns: new[] { "UserId", "BankId" });

        migrationBuilder.CreateIndex(
            name: "IX_PersonalQuestions_BankId",
            table: "PersonalQuestions",
            column: "BankId");

        migrationBuilder.CreateIndex(
            name: "IX_PersonalQuestions_UserId_BankId_IsDeleted",
            table: "PersonalQuestions",
            columns: new[] { "UserId", "BankId", "IsDeleted" });

        migrationBuilder.CreateIndex(
            name: "IX_PersonalPracticeAttemptAnswers_AttemptId",
            table: "PersonalPracticeAttemptAnswers",
            column: "AttemptId");

        migrationBuilder.CreateIndex(
            name: "IX_PersonalPracticeAttemptAnswers_QuestionId",
            table: "PersonalPracticeAttemptAnswers",
            column: "QuestionId");

        migrationBuilder.CreateIndex(
            name: "IX_PersonalQuestionOptions_QuestionId",
            table: "PersonalQuestionOptions",
            column: "QuestionId");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "PersonalPracticeAttemptAnswers");
        migrationBuilder.DropTable(name: "PersonalQuestionOptions");
        migrationBuilder.DropTable(name: "PermissionGroupPermissions");
        migrationBuilder.DropTable(name: "RolePermissionGroups");
        migrationBuilder.DropTable(name: "UserPermissionGroups");
        migrationBuilder.DropTable(name: "PersonalPracticeAttempts");
        migrationBuilder.DropTable(name: "PersonalQuestions");
        migrationBuilder.DropTable(name: "PermissionGroups");
        migrationBuilder.DropTable(name: "PersonalQuestionBanks");
    }
}
