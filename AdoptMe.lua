--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.6) ~  Much Love, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			local FlatIdent_7126A = 0;
			while true do
				if (FlatIdent_7126A == 0) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local FlatIdent_12703 = 0;
		local a;
		local b;
		while true do
			if (FlatIdent_12703 == 0) then
				a, b = Byte(ByteString, DIP, DIP + 2);
				DIP = DIP + 2;
				FlatIdent_12703 = 1;
			end
			if (FlatIdent_12703 == 1) then
				return (b * 256) + a;
			end
		end
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local FlatIdent_475BC = 0;
		local Str;
		local FStr;
		while true do
			if (FlatIdent_475BC == 3) then
				return Concat(FStr);
			end
			if (FlatIdent_475BC == 1) then
				Str = Sub(ByteString, DIP, (DIP + Len) - 1);
				DIP = DIP + Len;
				FlatIdent_475BC = 2;
			end
			if (FlatIdent_475BC == 2) then
				FStr = {};
				for Idx = 1, #Str do
					FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
				end
				FlatIdent_475BC = 3;
			end
			if (FlatIdent_475BC == 0) then
				Str = nil;
				if not Len then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
				end
				FlatIdent_475BC = 1;
			end
		end
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local FlatIdent_1076E = 0;
		local Instrs;
		local Functions;
		local Lines;
		local Chunk;
		local ConstCount;
		local Consts;
		while true do
			if (2 == FlatIdent_1076E) then
				for Idx = 1, gBits32() do
					local FlatIdent_7F35E = 0;
					local Descriptor;
					while true do
						if (FlatIdent_7F35E == 0) then
							Descriptor = gBits8();
							if (gBit(Descriptor, 1, 1) == 0) then
								local Type = gBit(Descriptor, 2, 3);
								local Mask = gBit(Descriptor, 4, 6);
								local Inst = {gBits16(),gBits16(),nil,nil};
								if (Type == 0) then
									local FlatIdent_A9A3 = 0;
									while true do
										if (FlatIdent_A9A3 == 0) then
											Inst[3] = gBits16();
											Inst[4] = gBits16();
											break;
										end
									end
								elseif (Type == 1) then
									Inst[3] = gBits32();
								elseif (Type == 2) then
									Inst[3] = gBits32() - (2 ^ 16);
								elseif (Type == 3) then
									local FlatIdent_40CF = 0;
									while true do
										if (FlatIdent_40CF == 0) then
											Inst[3] = gBits32() - (2 ^ 16);
											Inst[4] = gBits16();
											break;
										end
									end
								end
								if (gBit(Mask, 1, 1) == 1) then
									Inst[2] = Consts[Inst[2]];
								end
								if (gBit(Mask, 2, 2) == 1) then
									Inst[3] = Consts[Inst[3]];
								end
								if (gBit(Mask, 3, 3) == 1) then
									Inst[4] = Consts[Inst[4]];
								end
								Instrs[Idx] = Inst;
							end
							break;
						end
					end
				end
				for Idx = 1, gBits32() do
					Functions[Idx - 1] = Deserialize();
				end
				return Chunk;
			end
			if (1 == FlatIdent_1076E) then
				ConstCount = gBits32();
				Consts = {};
				for Idx = 1, ConstCount do
					local Type = gBits8();
					local Cons;
					if (Type == 1) then
						Cons = gBits8() ~= 0;
					elseif (Type == 2) then
						Cons = gFloat();
					elseif (Type == 3) then
						Cons = gString();
					end
					Consts[Idx] = Cons;
				end
				Chunk[3] = gBits8();
				FlatIdent_1076E = 2;
			end
			if (FlatIdent_1076E == 0) then
				Instrs = {};
				Functions = {};
				Lines = {};
				Chunk = {Instrs,Functions,nil,Lines};
				FlatIdent_1076E = 1;
			end
		end
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 25) then
					if (Enum <= 12) then
						if (Enum <= 5) then
							if (Enum <= 2) then
								if (Enum <= 0) then
									local B;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								elseif (Enum > 1) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								else
									local Edx;
									local Results;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Stk[A + 1])};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 3) then
								local B;
								local A;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
							elseif (Enum == 4) then
								local FlatIdent_99389 = 0;
								local A;
								while true do
									if (FlatIdent_99389 == 0) then
										A = nil;
										Stk[Inst[2]]();
										VIP = VIP + 1;
										FlatIdent_99389 = 1;
									end
									if (FlatIdent_99389 == 7) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										FlatIdent_99389 = 8;
									end
									if (FlatIdent_99389 == 9) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_99389 == 1) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_99389 = 2;
									end
									if (FlatIdent_99389 == 4) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										FlatIdent_99389 = 5;
									end
									if (FlatIdent_99389 == 5) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										FlatIdent_99389 = 6;
									end
									if (FlatIdent_99389 == 8) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_99389 = 9;
									end
									if (FlatIdent_99389 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										FlatIdent_99389 = 7;
									end
									if (FlatIdent_99389 == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_99389 = 3;
									end
									if (FlatIdent_99389 == 3) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										FlatIdent_99389 = 4;
									end
								end
							else
								local B;
								local A;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 8) then
							if (Enum <= 6) then
								local A;
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 7) then
								local B;
								local A;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 10) then
							if (Enum == 9) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							else
								do
									return;
								end
							end
						elseif (Enum == 11) then
							local Edx;
							local Results;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Results = {Stk[A](Stk[A + 1])};
							Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 18) then
						if (Enum <= 15) then
							if (Enum <= 13) then
								Stk[Inst[2]]();
							elseif (Enum > 14) then
								local FlatIdent_35A31 = 0;
								local A;
								while true do
									if (FlatIdent_35A31 == 0) then
										A = Inst[2];
										Stk[A] = Stk[A]();
										break;
									end
								end
							else
								local FlatIdent_189F0 = 0;
								local B;
								local A;
								while true do
									if (4 == FlatIdent_189F0) then
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_189F0 = 5;
									end
									if (FlatIdent_189F0 == 1) then
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										FlatIdent_189F0 = 2;
									end
									if (3 == FlatIdent_189F0) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_189F0 = 4;
									end
									if (FlatIdent_189F0 == 2) then
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_189F0 = 3;
									end
									if (FlatIdent_189F0 == 5) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										FlatIdent_189F0 = 6;
									end
									if (FlatIdent_189F0 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										break;
									end
									if (FlatIdent_189F0 == 0) then
										B = nil;
										A = nil;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_189F0 = 1;
									end
								end
							end
						elseif (Enum <= 16) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						elseif (Enum == 17) then
							Stk[Inst[2]] = Stk[Inst[3]];
						else
							local B;
							local A;
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
						end
					elseif (Enum <= 21) then
						if (Enum <= 19) then
							local B;
							local A;
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						elseif (Enum == 20) then
							local A = Inst[2];
							local C = Inst[4];
							local CB = A + 2;
							local Result = {Stk[A](Stk[A + 1], Stk[CB])};
							for Idx = 1, C do
								Stk[CB + Idx] = Result[Idx];
							end
							local R = Result[1];
							if R then
								local FlatIdent_5477B = 0;
								while true do
									if (FlatIdent_5477B == 0) then
										Stk[CB] = R;
										VIP = Inst[3];
										break;
									end
								end
							else
								VIP = VIP + 1;
							end
						else
							local B;
							local A;
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
						end
					elseif (Enum <= 23) then
						if (Enum == 22) then
							Stk[Inst[2]] = {};
						else
							local FlatIdent_8435E = 0;
							local Edx;
							local Results;
							local Limit;
							local B;
							local A;
							while true do
								if (3 == FlatIdent_8435E) then
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_8435E = 4;
								end
								if (5 == FlatIdent_8435E) then
									Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										local FlatIdent_DFF4 = 0;
										while true do
											if (FlatIdent_DFF4 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									FlatIdent_8435E = 6;
								end
								if (FlatIdent_8435E == 2) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									FlatIdent_8435E = 3;
								end
								if (FlatIdent_8435E == 0) then
									Edx = nil;
									Results, Limit = nil;
									B = nil;
									A = nil;
									FlatIdent_8435E = 1;
								end
								if (FlatIdent_8435E == 1) then
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									FlatIdent_8435E = 2;
								end
								if (FlatIdent_8435E == 7) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]]();
									VIP = VIP + 1;
									FlatIdent_8435E = 8;
								end
								if (FlatIdent_8435E == 4) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_8435E = 5;
								end
								if (FlatIdent_8435E == 6) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									FlatIdent_8435E = 7;
								end
								if (FlatIdent_8435E == 8) then
									Inst = Instr[VIP];
									do
										return;
									end
									break;
								end
							end
						end
					elseif (Enum == 24) then
						local FlatIdent_7DFA5 = 0;
						local A;
						local Results;
						local Edx;
						while true do
							if (FlatIdent_7DFA5 == 1) then
								Edx = 0;
								for Idx = A, Inst[4] do
									local FlatIdent_25A9F = 0;
									while true do
										if (FlatIdent_25A9F == 0) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								break;
							end
							if (FlatIdent_7DFA5 == 0) then
								A = Inst[2];
								Results = {Stk[A](Stk[A + 1])};
								FlatIdent_7DFA5 = 1;
							end
						end
					else
						local FlatIdent_72421 = 0;
						local A;
						while true do
							if (FlatIdent_72421 == 0) then
								A = Inst[2];
								Stk[A](Stk[A + 1]);
								break;
							end
						end
					end
				elseif (Enum <= 38) then
					if (Enum <= 31) then
						if (Enum <= 28) then
							if (Enum <= 26) then
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							elseif (Enum > 27) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							else
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 29) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								local FlatIdent_4508F = 0;
								while true do
									if (FlatIdent_4508F == 0) then
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
										break;
									end
								end
							end
						elseif (Enum > 30) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 34) then
						if (Enum <= 32) then
							if (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 33) then
							local FlatIdent_284EA = 0;
							local B;
							local A;
							while true do
								if (1 == FlatIdent_284EA) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									FlatIdent_284EA = 2;
								end
								if (FlatIdent_284EA == 4) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_284EA = 5;
								end
								if (FlatIdent_284EA == 0) then
									B = nil;
									A = nil;
									Stk[Inst[2]] = {};
									FlatIdent_284EA = 1;
								end
								if (FlatIdent_284EA == 9) then
									Stk[Inst[2]][Inst[3]] = Inst[4];
									break;
								end
								if (FlatIdent_284EA == 8) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_284EA = 9;
								end
								if (7 == FlatIdent_284EA) then
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_284EA = 8;
								end
								if (FlatIdent_284EA == 3) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									FlatIdent_284EA = 4;
								end
								if (5 == FlatIdent_284EA) then
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_284EA = 6;
								end
								if (FlatIdent_284EA == 6) then
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									FlatIdent_284EA = 7;
								end
								if (FlatIdent_284EA == 2) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									FlatIdent_284EA = 3;
								end
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 36) then
						if (Enum == 35) then
							local FlatIdent_869A9 = 0;
							local A;
							while true do
								if (FlatIdent_869A9 == 0) then
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									break;
								end
							end
						else
							local FlatIdent_276C2 = 0;
							local A;
							while true do
								if (FlatIdent_276C2 == 0) then
									A = nil;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_276C2 = 1;
								end
								if (FlatIdent_276C2 == 2) then
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_276C2 = 3;
								end
								if (FlatIdent_276C2 == 1) then
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_276C2 = 2;
								end
								if (FlatIdent_276C2 == 3) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									FlatIdent_276C2 = 4;
								end
								if (4 == FlatIdent_276C2) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
									break;
								end
							end
						end
					elseif (Enum > 37) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					else
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
					end
				elseif (Enum <= 45) then
					if (Enum <= 41) then
						if (Enum <= 39) then
							Stk[Inst[2]] = Env[Inst[3]];
						elseif (Enum > 40) then
							local FlatIdent_7873D = 0;
							while true do
								if (0 == FlatIdent_7873D) then
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_7873D = 1;
								end
								if (FlatIdent_7873D == 1) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_7873D = 2;
								end
								if (FlatIdent_7873D == 3) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_7873D = 4;
								end
								if (FlatIdent_7873D == 4) then
									VIP = Inst[3];
									break;
								end
								if (FlatIdent_7873D == 2) then
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_7873D = 3;
								end
							end
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 43) then
						if (Enum > 42) then
							local FlatIdent_3CDED = 0;
							local A;
							local Cls;
							while true do
								if (0 == FlatIdent_3CDED) then
									A = Inst[2];
									Cls = {};
									FlatIdent_3CDED = 1;
								end
								if (FlatIdent_3CDED == 1) then
									for Idx = 1, #Lupvals do
										local List = Lupvals[Idx];
										for Idz = 0, #List do
											local Upv = List[Idz];
											local NStk = Upv[1];
											local DIP = Upv[2];
											if ((NStk == Stk) and (DIP >= A)) then
												local FlatIdent_3B868 = 0;
												while true do
													if (FlatIdent_3B868 == 0) then
														Cls[DIP] = NStk[DIP];
														Upv[1] = Cls;
														break;
													end
												end
											end
										end
									end
									break;
								end
							end
						else
							local Edx;
							local Results, Limit;
							local B;
							local A;
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							Edx = 0;
							for Idx = A, Top do
								local FlatIdent_D14D = 0;
								while true do
									if (FlatIdent_D14D == 0) then
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
										break;
									end
								end
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Inst[4];
						end
					elseif (Enum == 44) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					elseif (Stk[Inst[2]] == Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 48) then
					if (Enum <= 46) then
						Stk[Inst[2]] = Upvalues[Inst[3]];
					elseif (Enum > 47) then
						local FlatIdent_803FB = 0;
						local B;
						local A;
						while true do
							if (5 == FlatIdent_803FB) then
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_803FB = 6;
							end
							if (FlatIdent_803FB == 4) then
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_803FB = 5;
							end
							if (FlatIdent_803FB == 3) then
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								FlatIdent_803FB = 4;
							end
							if (FlatIdent_803FB == 2) then
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_803FB = 3;
							end
							if (FlatIdent_803FB == 1) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								FlatIdent_803FB = 2;
							end
							if (0 == FlatIdent_803FB) then
								B = nil;
								A = nil;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								FlatIdent_803FB = 1;
							end
							if (6 == FlatIdent_803FB) then
								Stk[Inst[2]][Inst[3]] = Inst[4];
								break;
							end
						end
					else
						local B;
						local A;
						Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Inst[3]] = Inst[4];
					end
				elseif (Enum <= 50) then
					if (Enum == 49) then
						Stk[Inst[2]][Inst[3]] = Inst[4];
					else
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					end
				elseif (Enum == 51) then
					Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
				else
					local NewProto = Proto[Inst[3]];
					local NewUvals;
					local Indexes = {};
					NewUvals = Setmetatable({}, {__index=function(_, Key)
						local Val = Indexes[Key];
						return Val[1][Val[2]];
					end,__newindex=function(_, Key, Value)
						local FlatIdent_B1F4 = 0;
						local Val;
						while true do
							if (FlatIdent_B1F4 == 0) then
								Val = Indexes[Key];
								Val[1][Val[2]] = Value;
								break;
							end
						end
					end});
					for Idx = 1, Inst[4] do
						local FlatIdent_656E9 = 0;
						local Mvm;
						while true do
							if (FlatIdent_656E9 == 1) then
								if (Mvm[1] == 17) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
								break;
							end
							if (FlatIdent_656E9 == 0) then
								VIP = VIP + 1;
								Mvm = Instr[VIP];
								FlatIdent_656E9 = 1;
							end
						end
					end
					Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!423O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574033D3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F73686C6578776172652F4F72696F6E2F6D61696E2F736F75726365030A3O004D616B6557696E646F7703043O004E616D6503243O0053706C69736879536372697074F09F8EA92D41646F70742D4D652D5B5665722D352E305D030B3O00486964655072656D69756D010003093O00496E74726F54657874030D3O0053706C6973687953637269707403093O00496E74726F49636F6E03183O00726278612O73657469643A2O2F313831373035343932333503043O0049636F6E030A3O0053617665436F6E6669672O01030C3O00436F6E666967466F6C64657203093O004F72696F6E5465737403103O004D616B654E6F74696669636174696F6E03143O004C6F6164696E6720546865205363726970742O2E03073O00436F6E74656E74033C3O004D61792054616B652032302D3330207365636F6E64732074686973206973206E6F7420746865206578616374206C6F6461696E672074696D65E29D9703053O00496D61676503043O0054696D65026O00344003653O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F556C7472612D536372697074732F41646F70746D655363726970742F6D61696E2F41646F70746D655363726970742F4A5942524E44362D61646F70742D6D652E6C756103043O0077616974026O00F03F03103O0048532053706C6973687953637269707403073O004D616B65546162030E3O004475706520452O677320F09FA59A03173O00726278612O73657469643A2O2F2O34382O3334352O3938030B3O005072656D69756D4F6E6C79031A3O005363726970742053752O63652O7366752O6C79204C6F61646564031C3O004C6F6164696E672048617320622O656E2073752O63652O7366756C2003183O00726278612O73657469643A2O2F3137383439333132333538026O003E4003093O00412O6442752O746F6E03123O00457175697020452O677320546F204475706503083O0043612O6C6261636B03123O00436C69636B20546F204475706520452O6773030C3O00412O64506172616772617068030F3O004E6F7420576F726B696E673FE29D9703593O004475706520452O6773204E6F7420576F726B696E673F20436865636B206966207520617265206F6E206120707269766174652073657276657220746869732070726F6261626C79206361757365732074686520652O726F722E031D3O005363726970742053752O63652O7366752O6C79204C6F61646564E29D9703303O00456E6A6F7920546865205363726970742C2054696B746F6B2049732048532053706C69736879536372697074F09F8EA9030D3O004175746F4661726D20F09F9A9C031B3O004175746F6661726D20536F7572636520F09FA791E2808DF09F8CBE03643O00576974682055706461746564204665617475726573204175746F6661726D20506F6E792D4D696E6967616D6520416E642042752O6C726964652D4D696E6967616D6520416C736F2057697468205065746661726D7320416E642042616279204661726D7303223O00436C69636B20546F204C6F6164204175746F4661726D20536F7572636520F09F9A9C030E3O0044757065205065747320F09F94A8031D3O00457175697020612070657420752077616E7420746F2064757065E29D9703173O00436C69636B20546F2044757065205065747320F09F8EAF03593O00447570652050657473204E6F7420576F726B696E673F20436865636B206966207520617265206F6E206120707269766174652073657276657220746869732070726F6261626C79206361757365732074686520652O726F722E03263O00456E6A6F7920546865205363726970742C2048532053706C69736879536372697074F09F8EA903133O00496E66696E697465204275636B7320F09F92B803213O00436C69636B20746F206C6F616420496E66696E697465204275636B7320F09F92B8030C3O004D46522D4E465220F09F93A6031B3O004D4652204368616E6765722D28496E76656E746F7279F09F8E9229031B3O004E4652204368616E6765722D28496E76656E746F7279F09F8E9229030F3O00452O726F72732F427567733FE29D9703173O00507269766174652073657276657220452O726F72E29D9703C43O004265696E6720696E20612070726976617465207365727665722063616E20636175736520616C6F74206F6620746865206D61696E206665617475726573206F66207468652073637269707420746F206E6F7420776F726B20706C656173652074616B6520746869732061732061206E6F746520696620757220686176696E672070726F626C656D73207769746820736F6D657468696E67206E6F7420776F726B696E6720746869732069732070726F6261626C7920746865206361757365206F6620697403163O004D7920446973636F72642073657276657220F09F8EA9033E3O00506C65617365206A6F696E206D7920646973636F7264207365727665722069662075206E2O65642068656C70207769746820627567732F652O726F72732E03203O00436F7079204C696E6B20546F20446973636F72642053657276657220F09F8EAF00C23O00122A3O00013O00122O000100023O00202O00010001000300122O000300046O000100039O0000026O0001000200202O00013O00054O00033O000700302O00030006000700302O00030008000900302O0003000A000B00302O0003000C000D00302O0003000E000D00302O0003000F001000302O0003001100124O00010003000200202O00023O00134O00043O000400302O00040006001400302O00040015001600302O00040017000D00302O0004001800194O00020004000100122O000200013O00122O000300023O00202O00030003000300122O0005001A6O000300056O00023O00024O00020001000100122O0002001B3O00122O0003001C6O00020002000100122O000200013O00122O000300023O00202O00030003000300122O000500046O000300056O00023O00024O00020001000200202O0003000200054O00053O000700302O00050006000700302O00050008000900302O0005000A001D00302O0005000C000D00302O0005000E000D00302O0005000F001000302O0005001100124O00030005000200202O00040003001E4O00063O000300302O00060006001F00302O0006000E002000302O0006002100094O00040006000200202O0005000200134O00073O000400302O00070006002200302O00070015002300302O00070017002400302O0007001800254O00050007000100202O0005000400264O00073O000200302O00070006002700063400083O000100012O00113O00023O0010300007002800084O00050007000100202O0005000400264O00073O000200302O00070006002900063400080001000100012O00113O00023O0010050007002800084O00050007000100202O00050004002A00122O0007002B3O00122O0008002C6O00050008000100202O00050004002A00122O0007002D3O00122O0008002E6O00050008000100202600050003001E4O00073O000300302O00070006002F00302O0007000E002000302O0007002100094O00050007000200202O00060005002A00122O000800303O00122O000900316O00060009000100202O0006000500262O001600083O0002003031000800060032000233000900023O0010150008002800094O00060008000100202O00060005002A00122O0008002D3O00122O0009002E6O00060009000100202O00060003001E4O00083O000300302O00080006003300302O0008000E00200030310008002100092O00320006000800020020260007000600262O001600093O0002003031000900060034000634000A0003000100012O00113O00023O00103000090028000A4O00070009000100202O0007000600264O00093O000200302O000900060035000634000A0004000100012O00113O00023O00100500090028000A4O00070009000100202O00070006002A00122O0009002B3O00122O000A00366O0007000A000100202O00070006002A00122O0009002D3O00122O000A00376O0007000A000100202600070003001E2O002200093O000300302O00090006003800302O0009000E002000302O0009002100094O00070009000200202O0008000700264O000A3O000200302O000A00060039000233000B00053O001015000A0028000B4O0008000A000100202O00080007002A00122O000A002D3O00122O000B002E6O0008000B000100202O00080003001E4O000A3O000300302O000A0006003A00302O000A000E0020003031000A002100092O00320008000A00020020260009000800262O0016000B3O0002003031000B0006003B000233000C00063O001030000B0028000C4O0009000B000100202O0009000800264O000B3O000200302O000B0006003C000233000C00073O001015000B0028000C4O0009000B000100202O00090008002A00122O000B002D3O00122O000C002E6O0009000C000100202O00090003001E4O000B3O000300302O000B0006003D00302O000B000E0020003031000B002100092O00090009000B000200202O000A0009002A00122O000C003E3O00122O000D003F6O000A000D000100202O000A0009002A00122O000C00403O00122O000D00416O000A000D000100202O000A000900262O0016000C3O0002003031000C00060042000233000D00083O00101A000C0028000D2O0023000A000C00012O002B8O000A3O00013O00093O00093O0003103O004D616B654E6F74696669636174696F6E03043O004E616D65030C3O00452O672053656C6563746F7203073O00436F6E74656E7403153O00452O6720457175692O7065642053656C656374656403053O00496D61676503173O00726278612O73657469643A2O2F2O34382O3334352O393803043O0054696D65026O00144000094O00027O00206O00014O00023O000400302O00020002000300302O00020004000500302O00020006000700302O0002000800096O000200016O00017O00093O0003103O004D616B654E6F74696669636174696F6E03043O004E616D65030F3O00447570696E6720452O67734O2E03073O00436F6E74656E7403483O00447570696E6720697320696E2070726F63652O732O2E5B54616B65732061726F756E6420342D35206D696E757465735D20446F6E74204C65617665205468652047616D6520E29D9703053O00496D61676503173O00726278612O73657469643A2O2F2O34382O3334352O393803043O0054696D65026O005E4000094O00027O00206O00014O00023O000400302O00020002000300302O00020004000500302O00020006000700302O0002000800096O000200016O00017O00043O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574033C3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F4A756C4875627A2F4A756C4875622F6D61696E2F4A756C48756200083O0012173O00013O00122O000100023O00202O00010001000300122O000300046O000100039O0000026O000100016O00017O00093O0003103O004D616B654E6F74696669636174696F6E03043O004E616D6503163O0053656C656374656420457175692O706564205065747303073O00436F6E74656E7403233O00457175692O70656420506574732053752O63652O7366752O6C792053656C656374656403053O00496D61676503173O00726278612O73657469643A2O2F2O34382O3334352O393803043O0054696D65026O00144000094O00027O00206O00014O00023O000400302O00020002000300302O00020004000500302O00020006000700302O0002000800096O000200016O00017O00093O0003103O004D616B654E6F74696669636174696F6E03043O004E616D65030E3O00447570696E6720506574733O2E03073O00436F6E74656E7403443O00447570696E6720696E2050726F63652O732O2E5B54616B65732041726F756E6420342D35206D696E757465735D20446F6E74204C65617665205468652047616D65E29D9703053O00496D61676503173O00726278612O73657469643A2O2F2O34382O3334352O393803043O0054696D65026O005E4000094O00027O00206O00014O00023O000400302O00020002000300302O00020004000500302O00020006000700302O0002000800096O000200016O00017O000A3O0003073O007265717569726503043O0067616D6503073O007365727669636503113O005265706C69636174656453746F7261676503043O004673797303043O006C6F6164030A3O00436C69656E744461746103063O0075706461746503053O006D6F6E6579022O0080FF642OCD41000F3O0012133O00013O00122O000100023O00202O00010001000300122O000300046O00010003000200202O0001000100056O0002000200206O000600122O000100078O0002000200206O000800122O000100093O00122O0002000A8O000200016O00017O00153O00028O0003043O007761697403073O007265717569726503043O0067616D6503113O005265706C69636174656453746F72616765030D3O00436C69656E744D6F64756C657303043O00436F7265030A3O00436C69656E7444617461026O00F03F03083O006765745F6461746103083O00746F737472696E6703073O00506C6179657273030B3O004C6F63616C506C6179657203053O00706169727303093O00696E76656E746F727903043O0070657473030A3O0070726F7065727469657303093O006D6567615F6E656F6E2O0103083O007269646561626C6503073O00666C7961626C6500323O0012073O00014O002C000100023O00262D3O000F000100010004283O000F0001001227000300024O000400030001000100122O000300033O00122O000400043O00202O00040004000500202O00040004000600202O00040004000700202O0004000400084O0003000200024O000100033O00124O00093O00262D3O0002000100090004283O0002000100202500030001000A2O000B00030001000200122O0004000B3O00122O000500043O00202O00050005000C00202O00050005000D4O0004000200024O00020003000400122O0003000E3O00202O00040002000F00202O0004000400104O00030002000500044O002C0001001207000800013O00262D00080024000100090004283O002400010020250009000700110030310009001200130004283O002C000100262D0008001F000100010004283O001F000100202500090007001100302900090014001300202O00090007001100302O00090015001300122O000800093O00044O001F00010006140003001E000100020004283O001E00010004285O00010004283O000200010004285O00012O000A3O00017O00153O00028O00026O00F03F03083O006765745F6461746103083O00746F737472696E6703043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203053O00706169727303093O00696E76656E746F727903043O0070657473030A3O0070726F7065727469657303043O006E656F6E2O0103083O007269646561626C6503073O00666C7961626C6503043O007761697403073O007265717569726503113O005265706C69636174656453746F72616765030D3O00436C69656E744D6F64756C657303043O00436F7265030A3O00436C69656E744461746100403O0012073O00014O002C000100023O00262D3O0030000100020004283O003000010020250003000100032O000B00030001000200122O000400043O00122O000500053O00202O00050005000600202O0005000500074O0004000200024O00020003000400122O000300083O00202O00040002000900202O00040004000A4O00030002000500044O002D0001001207000800014O002C000900093O000E2000010013000100080004283O00130001001207000900013O00262D0009001B000100020004283O001B0001002025000A0007000B003031000A000C000D0004283O002D000100262D00090016000100010004283O00160001001207000A00013O00262D000A0022000100020004283O00220001001207000900023O0004283O0016000100262D000A001E000100010004283O001E0001002025000B0007000B003029000B000E000D00202O000B0007000B00302O000B000F000D00122O000A00023O00044O001E00010004283O001600010004283O002D00010004283O0013000100061400030011000100020004283O001100010004285O000100262D3O0002000100010004283O00020001001227000300104O000400030001000100122O000300113O00122O000400053O00202O00040004001200202O00040004001300202O00040004001400202O0004000400154O0003000200024O000100033O00124O00023O0004283O000200010004285O00012O000A3O00017O00053O00028O00030C3O00736574636C6970626F61726403253O00682O7470733A2O2F646973636F72642E636F6D2F696E766974652F7074484347596A6D535103053O007072696E74030E3O0062752O746F6E207072652O73656400123O0012073O00014O002C000100013O00262D3O0002000100010004283O00020001001207000100013O00262D00010005000100010004283O00050001001227000200023O001224000300036O00020002000100122O000200043O00122O000300056O00020002000100044O001100010004283O000500010004283O001100010004283O000200012O000A3O00017O00", GetFEnv(), ...);q
