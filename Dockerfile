# Use the .NET 8.0 ASP.NET runtime image for Linux
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Use the .NET 8.0 SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DiscountPortel/DiscountPortel.csproj", "DiscountPortel/"]
RUN dotnet restore "./DiscountPortel/DiscountPortel.csproj"
COPY . .
WORKDIR "/src/DiscountPortel"
RUN dotnet build "./DiscountPortel.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the application
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DiscountPortel.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Create the final image from the base image and copy the published output
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DiscountPortel.dll"]
