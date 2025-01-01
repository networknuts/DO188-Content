#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY . . 
RUN dotnet restore "./DockerDemo.csproj"
RUN dotnet build "DockerDemo.csproj" -c Release -o /app/build
RUN dotnet publish "DockerDemo.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS final
WORKDIR /app
EXPOSE 80
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet"]
CMD ["DockerDemo.dll"]
