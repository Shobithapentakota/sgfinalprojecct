# Use a Windows-based .NET image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-windowsservercore-ltsc2022 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:6.0-windowsservercore-ltsc2022 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DiscountPortel/DiscountPortel.csproj", "DiscountPortel/"]
RUN dotnet restore "./DiscountPortel/DiscountPortel.csproj"
COPY . .
WORKDIR "/src/DiscountPortel"
RUN dotnet build "./DiscountPortel.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DiscountPortel.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DiscountPortel.dll"]
