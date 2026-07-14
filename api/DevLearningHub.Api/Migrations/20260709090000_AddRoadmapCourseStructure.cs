using System;
using DevLearningHub.Api.Data;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DevLearningHub.Api.Migrations
{
    [DbContext(typeof(DevLearningHubDbContext))]
    [Migration("20260709090000_AddRoadmapCourseStructure")]
    public partial class AddRoadmapCourseStructure : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "LearningTracks",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Slug = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Level = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    EstimatedHours = table.Column<int>(type: "int", nullable: false),
                    ThumbnailUrl = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    SortOrder = table.Column<int>(type: "int", nullable: false),
                    IsPublished = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table => table.PrimaryKey("PK_LearningTracks", x => x.Id));

            migrationBuilder.CreateTable(
                name: "RoadmapCourses",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TrackId = table.Column<long>(type: "bigint", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Slug = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    ShortDescription = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Level = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    EstimatedHours = table.Column<int>(type: "int", nullable: false),
                    TotalModules = table.Column<int>(type: "int", nullable: false),
                    TotalLessons = table.Column<int>(type: "int", nullable: false),
                    RequirementsJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LearningOutcomesJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RelatedCourseIdsJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PrerequisiteCourseIdsJson = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ThumbnailUrl = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    SortOrder = table.Column<int>(type: "int", nullable: false),
                    IsPublished = table.Column<bool>(type: "bit", nullable: false),
                    RequiresSequentialCompletion = table.Column<bool>(type: "bit", nullable: false),
                    UnlockAfterCourseId = table.Column<long>(type: "bigint", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoadmapCourses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RoadmapCourses_LearningTracks_TrackId",
                        column: x => x.TrackId,
                        principalTable: "LearningTracks",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RoadmapModules",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CourseId = table.Column<long>(type: "bigint", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SortOrder = table.Column<int>(type: "int", nullable: false),
                    EstimatedMinutes = table.Column<int>(type: "int", nullable: false),
                    RequiresPreviousModuleCompletion = table.Column<bool>(type: "bit", nullable: false),
                    IsLockedByDefault = table.Column<bool>(type: "bit", nullable: false),
                    IsPublished = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoadmapModules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RoadmapModules_RoadmapCourses_CourseId",
                        column: x => x.CourseId,
                        principalTable: "RoadmapCourses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RoadmapLessons",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ModuleId = table.Column<long>(type: "bigint", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Type = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    VideoUrl = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    QuizSetId = table.Column<long>(type: "bigint", nullable: true),
                    CodingProblemId = table.Column<long>(type: "bigint", nullable: true),
                    EstimatedMinutes = table.Column<int>(type: "int", nullable: false),
                    SortOrder = table.Column<int>(type: "int", nullable: false),
                    IsPreview = table.Column<bool>(type: "bit", nullable: false),
                    IsPublished = table.Column<bool>(type: "bit", nullable: false),
                    RequiresPreviousLessonCompletion = table.Column<bool>(type: "bit", nullable: false),
                    IsRequired = table.Column<bool>(type: "bit", nullable: false),
                    UnlockAfterLessonId = table.Column<long>(type: "bigint", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoadmapLessons", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RoadmapLessons_CodingProblems_CodingProblemId",
                        column: x => x.CodingProblemId,
                        principalTable: "CodingProblems",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_RoadmapLessons_QuizSets_QuizSetId",
                        column: x => x.QuizSetId,
                        principalTable: "QuizSets",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_RoadmapLessons_RoadmapModules_ModuleId",
                        column: x => x.ModuleId,
                        principalTable: "RoadmapModules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserLessonProgresses",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    LessonId = table.Column<long>(type: "bigint", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    StartedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CompletedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    LastAccessedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserLessonProgresses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserLessonProgresses_RoadmapLessons_LessonId",
                        column: x => x.LessonId,
                        principalTable: "RoadmapLessons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserLessonProgresses_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(name: "IX_LearningTracks_IsPublished_IsDeleted_SortOrder", table: "LearningTracks", columns: new[] { "IsPublished", "IsDeleted", "SortOrder" });
            migrationBuilder.CreateIndex(name: "IX_LearningTracks_Slug", table: "LearningTracks", column: "Slug", unique: true);
            migrationBuilder.CreateIndex(name: "IX_RoadmapCourses_Slug", table: "RoadmapCourses", column: "Slug", unique: true);
            migrationBuilder.CreateIndex(name: "IX_RoadmapCourses_TrackId_IsPublished_IsDeleted_SortOrder", table: "RoadmapCourses", columns: new[] { "TrackId", "IsPublished", "IsDeleted", "SortOrder" });
            migrationBuilder.CreateIndex(name: "IX_RoadmapLessons_CodingProblemId", table: "RoadmapLessons", column: "CodingProblemId");
            migrationBuilder.CreateIndex(name: "IX_RoadmapLessons_ModuleId_IsPublished_IsDeleted_SortOrder", table: "RoadmapLessons", columns: new[] { "ModuleId", "IsPublished", "IsDeleted", "SortOrder" });
            migrationBuilder.CreateIndex(name: "IX_RoadmapLessons_QuizSetId", table: "RoadmapLessons", column: "QuizSetId");
            migrationBuilder.CreateIndex(name: "IX_RoadmapModules_CourseId_IsPublished_IsDeleted_SortOrder", table: "RoadmapModules", columns: new[] { "CourseId", "IsPublished", "IsDeleted", "SortOrder" });
            migrationBuilder.CreateIndex(name: "IX_UserLessonProgresses_LessonId", table: "UserLessonProgresses", column: "LessonId");
            migrationBuilder.CreateIndex(name: "IX_UserLessonProgresses_Status", table: "UserLessonProgresses", column: "Status");
            migrationBuilder.CreateIndex(name: "IX_UserLessonProgresses_UserId_LessonId", table: "UserLessonProgresses", columns: new[] { "UserId", "LessonId" }, unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "UserLessonProgresses");
            migrationBuilder.DropTable(name: "RoadmapLessons");
            migrationBuilder.DropTable(name: "RoadmapModules");
            migrationBuilder.DropTable(name: "RoadmapCourses");
            migrationBuilder.DropTable(name: "LearningTracks");
        }
    }
}
