FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5098

ENV ASPNETCORE_URLS=http://*:5098
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["containerised-web-api.csproj", "./"]
RUN dotnet restore "containerised-web-api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "containerised-web-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "containerised-web-api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "containerised-web-api.dll"]
