import re
import json

def toon_to_dict(toon_str):
    """
    Parser de TOON a diccionario Python.
    """
    lines = toon_str.strip().split('\n')
    result = {}
    stack = [(result, -1)]
    
    table_pattern = re.compile(r'^(\w+)\[(\d+)\]\{(.+)\}:\s*$')
    
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            i += 1
            continue
            
        indent = len(line) - len(line.lstrip())
        
        while stack and indent <= stack[-1][1]:
            stack.pop()
            
        if not stack:
            # Error de indentación o archivo mal formado, resetear a raíz
            stack = [(result, -1)]
            
        current_obj = stack[-1][0]
        
        # Detectar tabla
        table_match = table_pattern.match(stripped)
        if table_match:
            name, count, fields = table_match.groups()
            count = int(count)
            fields = [f.strip() for f in fields.split(',')]
            items = []
            for _ in range(count):
                i += 1
                if i >= len(lines): break
                row_values = []
                # Simple split por coma pero respetando comillas básicas
                row_values = [v.strip() for v in lines[i].split(',')]
                item = {}
                for idx, f in enumerate(fields):
                    if idx < len(row_values):
                        val = row_values[idx]
                        if val.startswith('"') and val.endswith('"'):
                            val = val[1:-1]
                        elif val.isdigit():
                            val = int(val)
                        elif val.lower() == 'true':
                            val = True
                        elif val.lower() == 'false':
                            val = False
                        elif val.lower() == 'null':
                            val = None
                        item[f] = val
                items.append(item)
            current_obj[name] = items
            i += 1
            continue

        if ':' in stripped:
            key, value = stripped.split(':', 1)
            key = key.strip()
            value = value.strip()
            
            if not value: # Es un objeto anidado
                new_obj = {}
                current_obj[key] = new_obj
                stack.append((new_obj, indent))
            else:
                if value.startswith('"') and value.endswith('"'):
                    value = value[1:-1]
                elif value.isdigit():
                    value = int(value)
                elif value.lower() == 'true':
                    value = True
                elif value.lower() == 'false':
                    value = False
                elif value.lower() == 'null':
                    value = None
                current_obj[key] = value
        
        i += 1
    return result

def dict_to_toon(obj, indent=0):
    """
    Convierte diccionario/lista a TOON.
    Optimiza listas de diccionarios como tablas.
    """
    lines = []
    spaces = " " * indent
    
    if isinstance(obj, list):
        if not obj:
            return "[]"
        if isinstance(obj[0], dict):
            # Convertir lista de dicts a tabla TOON
            fields = []
            for item in obj:
                for k in item.keys():
                    if k not in fields: fields.append(k)
            
            header = f"[{len(obj)}]{{{', '.join(fields)}}}:"
            lines.append(header)
            for item in obj:
                row = []
                for f in fields:
                    v = item.get(f)
                    if v is None: row.append("null")
                    elif isinstance(v, str): row.append(f'"{v}"')
                    elif isinstance(v, bool): row.append(str(v).lower())
                    else: row.append(str(v))
                lines.append(f"  {', '.join(row)}")
        else:
            return f"[{len(obj)}]: {', '.join(map(str, obj))}"
    
    elif isinstance(obj, dict):
        for k, v in obj.items():
            if isinstance(v, dict):
                lines.append(f"{spaces}{k}:")
                lines.append(dict_to_toon(v, indent + 2))
            elif isinstance(v, list) and v and isinstance(v[0], dict):
                fields = []
                for item in v:
                    for f_key in item.keys():
                        if f_key not in fields: fields.append(f_key)
                
                lines.append(f"{spaces}{k}[{len(v)}]{{{', '.join(fields)}}}:")
                for item in v:
                    row = []
                    for f in fields:
                        val = item.get(f)
                        if val is None: row.append("null")
                        elif isinstance(val, str): row.append(f'"{val}"')
                        elif isinstance(val, bool): row.append(str(val).lower())
                        else: row.append(str(val))
                    lines.append(f"{spaces}  {', '.join(row)}")
            elif isinstance(v, list):
                lines.append(f"{spaces}{k}[{len(v)}]: {', '.join(map(str, v))}")
            else:
                val_str = f'"{v}"' if isinstance(v, str) else str(v).lower() if isinstance(v, bool) else "null" if v is None else str(v)
                lines.append(f"{spaces}{k}: {val_str}")
                
    return "\n".join(lines)
