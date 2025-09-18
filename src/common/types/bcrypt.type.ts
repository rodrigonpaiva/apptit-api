export type Bcrypt = {
  compare(data: string, encrypted: string): Promise<boolean>;
  hash(data: string, saltOrRounds: number): Promise<string>;
};
