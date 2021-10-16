FROM mcr.microsoft.com/dotnet/sdk:5.0 as build

WORKDIR /src

COPY ["src/OzonEdu.StockApi/OzonEdu.StockApi.csproj", "src/OzonEdu.StockApi/"]

RUN dotnet restore "src/OzonEdu.StockApi/OzonEdu.StockApi.csproj"

COPY . .

WORKDIR "/src/src/OzonEdu.StockApi"

RUN dotnet build "OzonEdu.StockApi.csproj" -c  Release -o /app/build

From build as publish

RUN dotnet publish "OzonEdu.StockApi.csproj" -c  Release -o /app/publish
FROM mcr.microsoft.com/dotnet/aspnet:5.0 as runtime

WORKDIR /app

expose 80
expose 433

From runtime as final
WORKDIR /src
copy --from=publish /app/publish .
entrypoint ["dotnet","OzonEdu.StockApi.dll"]