export interface NamedEntity<T = any> {
  token: string,
}

export interface IServiceLocator {
  bind<T>(entity: NamedEntity<T>, value: T) : void;
  findByToken<T>(entity: NamedEntity<T>) : T;
  findByTokenOrNull<T>(entity: NamedEntity<T>) : T | undefined;
}

class ServiceLocator implements IServiceLocator {
  constructor() {
    console.log('create ioc');
  }

  private readonly _map: Map<string, any> = new Map<string, any>();

  bind<T>(entity: NamedEntity<T>, value: T): void {
    const {token} = entity;
    if(this._map.has(token)) throw new Error(`Has token '${token}'`);

    this._map.set(token, value);
  }

  findByToken<T>(entity: NamedEntity<T>): T {
    const value = this.findByTokenOrNull(entity);    
    if(value == null) throw new Error(`Unknown token '${entity.token}'`)

    return value;
  }

  findByTokenOrNull<T>(entity: NamedEntity<T>): T | undefined {
    return this._map.get(entity.token) as T | undefined;
  }
}

export const IOC : IServiceLocator = new ServiceLocator();
