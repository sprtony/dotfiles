import sys
import os
import requests
import json
import argparse
from toon_parser import dict_to_toon, toon_to_dict

# Cargar configuración desde .env local
script_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(script_dir, ".env")

config = {}
if os.path.exists(env_path):
    with open(env_path, "r") as f:
        for line in f:
            if "=" in line:
                key, value = line.strip().split("=", 1)
                config[key] = value

BASE_URL = config.get("BOOKSTACK_URL", "https://bookstack.avadig.com/api").rstrip('/')
TOKEN_ID = config.get("BOOKSTACK_TOKEN_ID")
TOKEN_SECRET = config.get("BOOKSTACK_TOKEN_SECRET")

if not TOKEN_ID or not TOKEN_SECRET:
    print("error: Credenciales no encontradas en scripts/.env")
    sys.exit(1)

headers = {
    "Authorization": f"Token {TOKEN_ID}:{TOKEN_SECRET}",
    "Content-Type": "application/json"
}

def call_api(method, endpoint, data=None, params=None, files=None):
    url = f"{BASE_URL}/{endpoint.lstrip('/')}"
    try:
        current_headers = headers.copy()
        if files:
            del current_headers["Content-Type"]
            response = requests.request(method, url, headers=current_headers, data=data, params=params, files=files)
        else:
            response = requests.request(method, url, headers=current_headers, json=data, params=params)
            
        response.raise_for_status()
        if response.status_code == 204:
            return {"success": True}
        return response.json()
    except requests.exceptions.HTTPError as e:
        return {"error": str(e), "response": response.json() if response.content else None}
    except Exception as e:
        return {"error": str(e)}

def output_result(result, format_type="toon"):
    if format_type == "json":
        print(json.dumps(result, indent=2))
    else:
        print(dict_to_toon(result))

def main():
    parser = argparse.ArgumentParser(description="BookStack API Client with TOON support")
    subparsers = parser.add_subparsers(dest="entity", help="Entidad a gestionar")

    entities = ["shelves", "books", "chapters", "pages", "attachments", "comments", "roles", "users", "image-gallery", "imports"]
    
    for entity in entities:
        p = subparsers.add_parser(entity)
        p.add_argument("action", choices=["list", "read", "create", "update", "delete", "export", "run"])
        p.add_argument("--id", help=f"ID de {entity}")
        p.add_argument("--data", help="JSON con datos")
        p.add_argument("--toon", help="TOON con datos")
        p.add_argument("--format", choices=["html", "pdf", "plaintext", "markdown", "zip"], default="html")
        p.add_argument("--output", choices=["json", "toon"], default="toon")
        p.add_argument("--file", help="Ruta de archivo para upload")

    # Búsqueda
    p_search = subparsers.add_parser("search")
    p_search.add_argument("query")
    p_search.add_argument("--count", type=int, default=20)
    p_search.add_argument("--output", choices=["json", "toon"], default="toon")

    args = parser.parse_args()

    if not args.entity:
        parser.print_help()
        return

    # Lógica de Búsqueda
    if args.entity == "search":
        result = call_api("GET", "search", params={"query": args.query, "count": args.count})
        output_result(result, args.output)
        return

    # Lógica CRUD General
    endpoint = args.entity
    data = {}
    if args.toon:
        data = toon_to_dict(args.toon)
    elif args.data:
        data = json.loads(args.data)
    
    if args.action == "list":
        output_result(call_api("GET", endpoint), args.output)
    elif args.action == "read":
        output_result(call_api("GET", f"{endpoint}/{args.id}"), args.output)
    elif args.action == "create":
        files = None
        if args.file and os.path.exists(args.file):
            files = {'file': open(args.file, 'rb')}
        output_result(call_api("POST", endpoint, data=data, files=files), args.output)
    elif args.action == "update":
        output_result(call_api("PUT", f"{endpoint}/{args.id}", data=data), args.output)
    elif args.action == "delete":
        output_result(call_api("DELETE", f"{endpoint}/{args.id}"), args.output)
    elif args.action == "export":
        output_result(call_api("GET", f"{endpoint}/{args.id}/export/{args.format}"), args.output)
    elif args.action == "run":
        output_result(call_api("POST", f"{endpoint}/{args.id}/run"), args.output)

if __name__ == "__main__":
    main()
