#include <core.p4>
#include <psa.p4>

const bit<16> TYPE_IPV4 = 0x800;
const bit<8>  TYPE_TCP  = 6;

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> ether_type;
}

header ipv4_t {
    bit<8> ver_ihl;
    bit<8> diffserv;
    bit<16> total_len;
    bit<16> identification;
    bit<16> flags_offset;
    bit<8> ttl;
    bit<8> protocol;
    bit<16> hdr_checksum;
    bit<32> src_addr;
    bit<32> dst_addr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<8>  dataOffset_res;
    bit<8> flags;
//    bit<4>  res;
/*    bit<1>  cwr;
    bit<1>  ece;
    bit<1>  urg;
    bit<1>  ack;
    bit<1>  psh;
    bit<1>  rst;
    bit<1>  syn;
    bit<1>  fin;
*/
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

struct headers_t {
    ethernet_t ethernet;
    ipv4_t ipv4;
    tcp_t  tcp;
}

struct local_metadata_t {}

struct empty_metadata_t {}

parser packet_parser(
    packet_in pkt,
    out headers_t hdrs,
    inout local_metadata_t local_metadata,
    in psa_ingress_parser_input_metadata_t standard_metadata,
    in empty_metadata_t resub_meta,
    in empty_metadata_t recirc_meta)
{
    state start {
        transition parse_ethernet;
    }
    state parse_ethernet {
        pkt.extract(hdrs.ethernet);
        transition select(hdrs.ethernet.ether_type) {
            TYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        pkt.extract(hdrs.ipv4);
        transition select(hdrs.ipv4.protocol){
            TYPE_TCP: parse_tcp;
            default: accept;
        }
    }

    state parse_tcp {
        pkt.extract(hdrs.tcp);
        transition accept;
    }
}

control packet_deparser(
    packet_out packet,
    out empty_metadata_t clone_i2e_meta,
    out empty_metadata_t resubmit_meta,
    out empty_metadata_t normal_meta,
    inout headers_t headers,
    in local_metadata_t local_metadata,
    in psa_ingress_output_metadata_t istd)
{
    // InternetChecksum() cksum;

    apply {
/*         headers.ipv4.hdr_checksum = 0;
        cksum.clear();
        // cksum.add() requires 16-bit alignment.
        cksum.add(
            headers.ipv4
        );
        headers.ipv4.hdr_checksum = cksum.get(); */
        packet.emit(headers.ethernet);
        packet.emit(headers.ipv4);
        packet.emit(headers.tcp);
    }
}

control ingress(inout headers_t headers,
    inout local_metadata_t local_metadata1,
    in psa_ingress_input_metadata_t istd,
    inout psa_ingress_output_metadata_t ostd)
{
    action drop() {
        ingress_drop(ostd);
    }

    action ipv4_fwd(
        bit<48> ethernet_dst_addr,
        bit<48> ethernet_src_addr,
        bit<32> port_out
    ) {
        send_to_port(ostd, (PortId_t) port_out);
        headers.ethernet.src_addr = ethernet_src_addr;
        headers.ethernet.dst_addr = ethernet_dst_addr;
        // headers.ipv4.ttl = headers.ipv4.ttl - 1;

        if ((PortId_t) port_out == (PortId_t) 0) {
            if (headers.tcp.flags == 0x2) {
            //    send_to_port(ostd, (PortId_t) 2);
		drop();
            }
        }
    }

    table ipv4_table {
        key = {
            headers.ipv4.dst_addr: exact;
        }
        actions = {
            ipv4_fwd;
            drop;
        }
        const default_action = drop;
        size =  1024 * 1024;
    }

    apply {
        ipv4_table.apply();
    }
}


control egress(
    inout headers_t headers,
    inout local_metadata_t local_metadata,
    in psa_egress_input_metadata_t istd,
    inout psa_egress_output_metadata_t ostd)
{
    apply {}
}

parser egress_parser(
    packet_in buffer,
    out headers_t headers,
    inout local_metadata_t local_metadata,
    in psa_egress_parser_input_metadata_t istd,
    in empty_metadata_t normal_meta,
    in empty_metadata_t clone_i2e_meta,
    in empty_metadata_t clone_e2e_meta)
{
    state start {
        transition accept;
    }
}

control egress_deparser(
    packet_out packet,
    out empty_metadata_t clone_e2e_meta,
    out empty_metadata_t recirculate_meta,
    inout headers_t headers,
    in local_metadata_t local_metadata,
    in psa_egress_output_metadata_t istd,
    in psa_egress_deparser_input_metadata_t edstd)
{
    apply {}
}

IngressPipeline(packet_parser(), ingress(), packet_deparser()) pipe;

EgressPipeline(egress_parser(), egress(), egress_deparser()) ep;

PSA_Switch(pipe, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;
