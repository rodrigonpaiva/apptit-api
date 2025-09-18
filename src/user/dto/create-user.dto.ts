import { Role } from '@prisma/client';
import { IsEmail, IsString, IsEnum } from 'class-validator';

export class CreateUserDto {
  @IsString()
  name: string;

  @IsEmail()
  email: string;

  @IsString()
  password: string;

  @IsEnum(Role)
  role: Role;

  @IsString()
  avatar: string;

  @IsString()
  tenantId: string;
}
