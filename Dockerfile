FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
WORKDIR /build
RUN git clone --depth=1 -b separation https://github.com/Coflnet/HypixelSkyblock.git dev
WORKDIR /build/sky
COPY SkyMcConnect.csproj SkyMcConnect.csproj
RUN dotnet restore
COPY . .
RUN touch /build/dev/keyfile.p12 
RUN cp -n /build/dev/appsettings.json /build/dev/custom.conf.json
RUN dotnet publish -c release

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app

COPY --from=build /build/sky/bin/release/net5.0/publish/ .
RUN mkdir -p ah/files

ENTRYPOINT ["dotnet", "SkyMcConnect.dll"]

VOLUME /data

