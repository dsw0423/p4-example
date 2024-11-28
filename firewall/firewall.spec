
struct ethernet_t {
	bit<48> dst_addr
	bit<48> src_addr
	bit<16> ether_type
}

struct ipv4_t {
	bit<8> ver_ihl
	bit<8> diffserv
	bit<16> total_len
	bit<16> identification
	bit<16> flags_offset
	bit<8> ttl
	bit<8> protocol
	bit<16> hdr_checksum
	bit<32> src_addr
	bit<32> dst_addr
}

struct tcp_t {
	bit<16> srcPort
	bit<16> dstPort
	bit<32> seqNo
	bit<32> ackNo
	bit<8> dataOffset_res
	bit<8> flags
	bit<16> window
	bit<16> checksum
	bit<16> urgentPtr
}

struct psa_ingress_output_metadata_t {
	bit<8> class_of_service
	bit<8> clone
	bit<16> clone_session_id
	bit<8> drop
	bit<8> resubmit
	bit<32> multicast_group
	bit<32> egress_port
}

struct psa_egress_output_metadata_t {
	bit<8> clone
	bit<16> clone_session_id
	bit<8> drop
}

struct psa_egress_deparser_input_metadata_t {
	bit<32> egress_port
}

struct ipv4_fwd_arg_t {
	bit<48> ethernet_dst_addr
	bit<48> ethernet_src_addr
	bit<32> port_out
}

header ethernet instanceof ethernet_t
header ipv4 instanceof ipv4_t
header tcp instanceof tcp_t

struct local_metadata_t {
	bit<32> psa_ingress_input_metadata_ingress_port
	bit<8> psa_ingress_output_metadata_drop
	bit<32> psa_ingress_output_metadata_multicast_group
	bit<32> psa_ingress_output_metadata_egress_port
}
metadata instanceof local_metadata_t

action drop_1 args none {
	mov m.psa_ingress_output_metadata_drop 1
	return
}

action ipv4_fwd args instanceof ipv4_fwd_arg_t {
	mov m.psa_ingress_output_metadata_drop 0
	mov m.psa_ingress_output_metadata_multicast_group 0x0
	mov m.psa_ingress_output_metadata_egress_port t.port_out
	mov h.ethernet.src_addr t.ethernet_src_addr
	mov h.ethernet.dst_addr t.ethernet_dst_addr
	jmpneq LABEL_END t.port_out 0x0
	jmpneq LABEL_END h.tcp.flags 0x2
	mov m.psa_ingress_output_metadata_drop 1
	mov m.psa_ingress_output_metadata_multicast_group 0x0
	mov m.psa_ingress_output_metadata_egress_port t.port_out
	LABEL_END :	return
}

table ipv4_table {
	key {
		h.ipv4.dst_addr exact
	}
	actions {
		ipv4_fwd
		drop_1
	}
	default_action drop_1 args none const
	size 0x100000
}


apply {
	rx m.psa_ingress_input_metadata_ingress_port
	mov m.psa_ingress_output_metadata_drop 0x1
	extract h.ethernet
	jmpeq PACKET_PARSER_PARSE_IPV4 h.ethernet.ether_type 0x800
	jmp PACKET_PARSER_ACCEPT
	PACKET_PARSER_PARSE_IPV4 :	extract h.ipv4
	jmpeq PACKET_PARSER_PARSE_TCP h.ipv4.protocol 0x6
	jmp PACKET_PARSER_ACCEPT
	PACKET_PARSER_PARSE_TCP :	extract h.tcp
	PACKET_PARSER_ACCEPT :	table ipv4_table
	jmpneq LABEL_DROP m.psa_ingress_output_metadata_drop 0x0
	emit h.ethernet
	emit h.ipv4
	emit h.tcp
	tx m.psa_ingress_output_metadata_egress_port
	LABEL_DROP :	drop
}


