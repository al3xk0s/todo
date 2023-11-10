export type ObjectMap<V> = Record<string, V>;

export type JsonPrimitive = string | boolean | number | null;

export interface JsonObject {
    [k: string] : JsonData
}

export type JsonArray = JsonData[];

export type JsonData = JsonObject | JsonPrimitive | JsonArray;